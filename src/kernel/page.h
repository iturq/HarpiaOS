#ifndef PAGE_HEADER
#define PAGE_HEADER 1

#include "kernel.h"

//PML4E Table
//PML4E reference PDPTE
#define PML4E_PRESENT                           (1 << 0)
#define PML4E_READ_WRITE                        (1 << 1)
#define PML4E_USER_SUPERVISOR                   (1 << 2)
#define PML4E_PAGE_LEVEL_WRITE_THROUGH          (1 << 3)
#define PML4E_PAGE_LEVEL_CACHE_DISABLE          (1 << 4)
#define PML4E_ACCESSED                          (1 << 5)
#define PML4E_PHYSICAL_ADDRESS                  (0x000FFFFFFFFFF000)
#define PML4E_EXECUTE_DISABLE                   (1 << 31)

//PDPTE  - Page-directory-pointer table
//PDPTE 1GB
#define PDPTE_1GB_PRESENT                       (1 << 0)
#define PDPTE_1GB_READ_WRITE                    (1 << 1)
#define PDPTE_1GB_USER_SUPREVISOR               (1 << 2)
#define PDPTE_1GB_PAGE_LEVEL_WRITE_THROUGH      (1 << 3)
#define PDPTE_1GB_PAGE_LEVEL_CACHE_DISABLE      (1 << 4)
#define PDPTE_1GB_ACCESSED                      (1 << 5)
#define PDPTE_1GB_DIRTY                         (1 << 6)
#define PDPTE_1GB_PAGE_SIZE                     (1 << 7)
#define PDPTE_1GB_GLOBAL                        (1 << 8)
#define PDPTE_1GB_PAGE_ATTRIBUTE_TABLE          (1 << 12)
#define PDPTE_1GB_PHYSICAL_ADDRESS              (0x000FFFFFC0000000)
#define PDPTE_1GB_EXECUTE_DISABLE               (1 << 31)

//PDPTE reference PDE
#define PDPTE_PRESENT                           (1 << 0)
#define PDPTE_READ_WRITE                        (1 << 1)
#define PDPTE_USER_SUPREVISOR                   (1 << 2)
#define PDPTE_PAGE_LEVEL_WRITE_THROUGH          (1 << 3)
#define PDPTE_PAGE_LEVEL_CACHE_DISABLE          (1 << 4)
#define PDPTE_ACCESSED                          (1 << 5)
#define PDPTE_PHYSICAL_ADDRESS                  (0x000FFFFFFFFFF000)
#define PDPTE_EXECUTE_DISABLE                   (1 << 31)

//PDE    - Page Directory
//PDE 2MB Page
#define PDE_2MB_PRESENT                         (1 << 0)
#define PDE_2MB_READ_WRITE                      (1 << 1)
#define PDE_2MB_USER_SUPREVISOR                 (1 << 2)
#define PDE_2MB_PAGE_LEVEL_WRITE_THROUGH        (1 << 3)
#define PDE_2MB_PAGE_LEVEL_CACHE_DISABLE        (1 << 4)
#define PDE_2MB_ACCESSED                        (1 << 5)
#define PDE_2MB_DIRTY                           (1 << 6)
#define PDE_2MB_PAGE_SIZE                       (1 << 7)
#define PDE_2MB_GLOBAL                          (1 << 8)
#define PDE_2MB_PAGE_ATTRIBUTE_TABLE            (1 << 12)
#define PDE_2MB_PHYSICAL_ADDRESS                (0x000FFFFFFFE00000)
#define PDE_2MB_EXECUTE_DISABLE                 (1 << 31)

//PDE reference PTE
#define PDE_PRESENT                             (1 << 0)
#define PDE_READ_WRITE                          (1 << 1)
#define PDE_USER_SUPREVISOR                     (1 << 2)
#define PDE_PAGE_LEVEL_WRITE_THROUGH            (1 << 3)
#define PDE_PAGE_LEVEL_CACHE_DISABLE            (1 << 4)
#define PDE_ACCESSED                            (1 << 5)
#define PDE_PHYSICAL_ADDRESS                    (0x000FFFFFFFFFF000)
#define PDE_EXECUTE_DISABLE                     (1 << 31)

//PTE    - Page Table
#define PTE_PRESENT                             (1 << 0)
#define PTE_READ_WRITE                          (1 << 1)
#define PTE_USER_SUPREVISOR                     (1 << 2)
#define PTE_PAGE_LEVEL_WRITE_THROUGH            (1 << 3)
#define PTE_PAGE_LEVEL_CACHE_DISABLE            (1 << 4)
#define PTE_ACCESSED                            (1 << 5)
#define PTE_DIRTY                               (1 << 6)
#define PTE_PAGE_ATTRIBUTE_TABLE                (1 << 7)
#define PTE_GLOBAL                              (1 << 8)
#define PTE_PHYSICAL_ADDRESS                    (0x000FFFFFFFFFF000)
#define PTE_EXECUTE_DISABLE                     (1 << 31)

#define HIGH_ADDRESS_BASE                       (0x010000000000)
#define NUM_1GB                                 (0x40000000)
#define NUM_2MB                                 (0x00200000)
#define NUM_1MB                                 (0x00100000)
#define NUM_4KB                                 (0x1000)
#define NUM_1KB                                 (0x0400)

typedef struct pageentry
{
    union
    {
        uint64_t entry64;
        uint32_t entry32[2];
        uint16_t entry16[4];
        uint8_t  entry8[8];
    };
}pageentry_t;

typedef struct pageteble
{
    pageentry_t entry[512];
}pagetable_t;

int pageinit(uint64_t memsize);
int pagecacheset(uint64_t baseaddress, uint64_t topaddress);
int pagemapset(uint64_t baseaddress, uint64_t lenght, uint8_t type);

#endif