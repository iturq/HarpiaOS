#include "page.h"
#include "utils.h"
#include "console.h"

#include <cpuid.h>

#define PAGE_MAP_SIZE                               (2097152)     // 2MB
#define PAGE_MAP_MAX                                (512)//2048
#define PAGE_TABLE_SIZE                             (4096)
#define PAGE_ALIGN_ADDRESS(address, value)          ((address + value - 1) & ~(value - 1))

uint8_t pagemap[PAGE_MAP_MAX];
uint64_t memorysize;

pagetable_t *pml4e;
pagetable_t *pdpte;
pagetable_t pgentry[32] __attribute__ ((aligned (4096)));
pageentry_t *pagecache;
uint8_t *pagecachemap;
uint32_t pagecachenumentries;

uint64_t phystovirt(uint64_t address)
{
    return address | HIGH_ADDRESS_BASE;
}

uint64_t virttophys(uint64_t address)
{
    return address & ~HIGH_ADDRESS_BASE;
}

uint32_t check1gbpagesupport()
{
    uint32_t eax, edx, unused;
    eax = edx = unused = 0;
    __get_cpuid(0x80000001, &eax, &unused, &unused, &edx);
    return (edx & (1 << 26));
}

void set2mbpage()
{

}

int pageinit(uint64_t memsize)
{
    uint32_t numentry;
    memorysize = memsize;

    pml4e = (pagetable_t *)phystovirt(readcr3());
    pdpte = (pagetable_t *)phystovirt(pml4e->entry[2].entry64 & PML4E_PHYSICAL_ADDRESS);

    if(check1gbpagesupport() != 0)
    {
        numentry = (memorysize / NUM_1GB) + 1;
        for (uint64_t i = 0; i < numentry && i < PAGE_MAP_MAX; i++)
        {
            pdpte->entry[i].entry64 = (i * NUM_1GB) | PDPTE_1GB_PAGE_SIZE | PDPTE_1GB_PRESENT | PDPTE_1GB_READ_WRITE;
        }
    }
    else
    {
        numentry = (memorysize / NUM_1GB) + 1;
        for (uint64_t k = 0; k < numentry && k < 32; k++)
        {
            pdpte->entry[k].entry64 = (uint64_t)&pgentry[k] | PDPTE_1GB_PRESENT | PDPTE_1GB_READ_WRITE;
            for (uint64_t i = 0; i < PAGE_MAP_MAX; i++)
            {
                pgentry[k].entry[i].entry64 = (i * NUM_2MB) | PDE_2MB_PAGE_SIZE | PDE_2MB_PRESENT | PDE_2MB_READ_WRITE;
            }
        }
    }

    //write to cr3 to flush page cache
    writecr3((uint64_t) virttophys((uint64_t) pml4e));

    return 0;
}

int pagecacheset(uint64_t baseaddress, uint64_t topaddress)
{
    uint64_t basealign, topalign;

    basealign = PAGE_ALIGN_ADDRESS(baseaddress, PAGE_TABLE_SIZE);
    topalign = PAGE_ALIGN_ADDRESS(topaddress, PAGE_TABLE_SIZE) - PAGE_TABLE_SIZE;

    pagecachemap = (uint8_t*)(basealign);
    pagecache = (pageentry_t *)(basealign + PAGE_TABLE_SIZE);
    pagecachenumentries = ((topalign - basealign) / PAGE_TABLE_SIZE) - 1;

    for (uint32_t i = 0; i < pagecachenumentries; i++)
    {
        pagecachemap[i] = 0;
    }

    return 0;
}

int pagemapset(uint64_t baseaddress, uint64_t lenght, uint8_t type)
{
    uint64_t basepage, numpage;

    basepage = baseaddress / PAGE_MAP_SIZE;
    numpage = (baseaddress + lenght) / PAGE_MAP_SIZE;

    for (uint64_t i = basepage; i <= numpage && i < PAGE_MAP_MAX; i++)
    {
        if(pagemap[i] < type)
        {
            pagemap[i] = type;
        }
    }
    
    return 0;
}