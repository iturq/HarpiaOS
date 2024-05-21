; MACRO NASM file

;eflags register
%define EFLAGS_IDENTIFICATION                   (1 << 21)
%define EFLAGS_VIRTUAL_INTERRUPT_PENDING        (1 << 20)
%define EFLAGS_VIRTUAL_INTERRUPT                (1 << 19)
%define EFLAGS_ALIGNMENT_CHECK                  (1 << 18)
%define EFLAGS_VIRTUAL_8086_MODE                (1 << 17)
%define EFLAGS_RESUME                           (1 << 16)
%define EFLAGS_NESTED_TASK                      (1 << 14)
%define EFLAGS_IO_PRIVILEGE_LEVEL               (3 << 12)
%define EFLAGS_INTERRUPT_ENABLE                 (1 << 9)
%define EFLAGS_TRAP                             (1 << 8)

%define EFLAGS_TF                               EFLAGS_TRAP
%define EFLAGS_IF                               EFLAGS_INTERRUPT_ENABLE
%define EFLAGS_IOPL                             EFLAGS_IO_PRIVILEGE_LEVEL
%define EFLAGS_NT                               EFLAGS_NESTED_TASK
%define EFLAGS_RF                               EFLAGS_RESUME
%define EFLAGS_VM                               EFLAGS_VIRTUAL_8086_MODE
%define EFLAGS_AC                               EFLAGS_ALIGNMENT_CHECK
%define EFLAGS_VIF                              EFLAGS_VIRTUAL_INTERRUPT
%define EFLAGS_VIP                              EFLAGS_VIRTUAL_INTERRUPT_PENDING
%define EFLAGS_ID                               EFLAGS_IDENTIFICATION

;cr0 register
%define CR0_PAGING                              (1 << 31)
%define CR0_CACHE_DISABLE                       (1 << 30)
%define CR0_NOT_WRITE_THROUGH                   (1 << 29)
%define CR0_ALIGNMENT_MASK                      (1 << 18)
%define CR0_WRITE_PROTECT                       (1 << 16)
%define CR0_NUMERIC_ERROR                       (1 << 5)
%define CR0_EXTENSION_TYPE                      (1 << 4)
%define CR0_TASK_SWITCHED                       (1 << 3)
%define CR0_X87_EMULATION                       (1 << 2)
%define CR0_MONITOR_COPROCESSOR                 (1 << 1)
%define CR0_PROTECTION_ENABLE                   (1 << 0)

%define CR0_PG                                  CR0_PAGING
%define CR0_CD                                  CR0_CACHE_DISABLE
%define CR0_NW                                  CR0_NOT_WRITE_THROUGH
%define CR0_AM                                  CR0_ALIGNMENT_MASK
%define CR0_WP                                  CR0_WRITE_PROTECT
%define CR0_NE                                  CR0_NUMERIC_ERROR
%define CR0_ET                                  CR0_EXTENSION_TYPE
%define CR0_TS                                  CR0_TASK_SWITCHED
%define CR0_EM                                  CR0_X87_EMULATION
%define CR0_MP                                  CR0_MONITOR_COPROCESSOR
%define CR0_PE                                  CR0_PROTECTION_ENABLE

;cr3 register
%define CR3_PAGE_LEVEL_CACHE_DISABLE            (1 << 4)
%define CR3_PAGE_LEVEL_WRITE_TROUGH             (1 << 3)

%define CR3_PCD                                 CR3_PAGE_LEVEL_CACHE_DISABLE
%define CR3_PWT                                 CR3_PAGE_LEVEL_WRITE_TROUGH

;cr4 register
%define CR4_USER_INTERRUPTS_ENABLE_BIT          (1 << 25)
%define CR4_ENABLE_PROTECTION_KEYS_SUPERVISOR   (1 << 24)
%define CR4_CONTROL_FLOW_ENFORCEMENT_TECHNOLOGY (1 << 23)
%define CR4_ENABLE_PROTECTION_KEYS_USER         (1 << 22)
%define CR4_SMAP_ENABLE_BIT                     (1 << 21)
%define CR4_SMEP_ENABLE_BIT                     (1 << 20)
%define CR4_KEY_LOCKER_ENABLE_BIT               (1 << 19)
%define CR4_XSAVE_PROCESSOR_EXTENDED_STATES     (1 << 18)
%define CR4_PCID_ENABLE_BIT                     (1 << 17)
%define CR4_FSGSBASE_ENABLE_BIT                 (1 << 16)
%define CR4_SMX_ENABLE_BIT                      (1 << 14)
%define CR4_VMX_ENABLE_BIT                      (1 << 13)
%define CR4_57_BIT_LINEAR_ADDRESSES             (1 << 12)
%define CR4_USER_MODE_INSTRUCTION_PREVENTION    (1 << 11)
%define CR4_OS_UNMASKED_SIMD_FP_EXCEPTIONS      (1 << 10)
%define CR4_OS_SUPPORT_FXSAVE_FXSTOR            (1 << 9)
%define CR4_PERF_MONITORING_COUNTER_ENABLE      (1 << 8)
%define CR4_PAGE_GLOBAL_ENABLE                  (1 << 7)
%define CR4_MACHINE_CHECK_ENABLE                (1 << 6)
%define CR4_PHYSICAL_ADDRESS_EXTENSION          (1 << 5)
%define CR4_PAGE_SIZE_EXTENSIONS                (1 << 4)
%define CR4_DEBUGGING_EXTENSIONS                (1 << 3)
%define CR4_TIME_STAMP_DISABLE                  (1 << 2)
%define CR4_PROTECTED_MODE_VIRTUAL_INTERRUPTS   (1 << 1)
%define CR4_VIRTUAL_8086_MODE_EXTENSIONS        (1 << 0)

%define CR4_VMI                                 CR4_VIRTUAL_8086_MODE_EXTENSIONS
%define CR4_PVI                                 CR4_PROTECTED_MODE_VIRTUAL_INTERRUPTS
%define CR4_TSD                                 CR4_TIME_STAMP_DISABLE
%define CR4_DE                                  CR4_DEBUGGING_EXTENSIONS
%define CR4_PSE                                 CR4_PAGE_SIZE_EXTENSIONS
%define CR4_PAE                                 CR4_PHYSICAL_ADDRESS_EXTENSION
%define CR4_MCE                                 CR4_MACHINE_CHECK_ENABLE
%define CR4_PGE                                 CR4_PAGE_GLOBAL_ENABLE
%define CR4_PCE                                 CR4_PERF_MONITORING_COUNTER_ENABLE
%define CR4_OSFXSR                              CR4_OS_SUPPORT_FXSAVE_FXSTOR
%define CR4_OSXMMEXCPT                          CR4_OS_UNMASKED_SIMD_FP_EXCEPTIONS
%define CR4_UMIP                                CR4_USER_MODE_INSTRUCTION_PREVENTION
%define CR4_LA57                                CR4_57_BIT_LINEAR_ADDRESSES
%define CR4_VMX                                 CR4_VMX_ENABLE_BIT
%define CR4_SMXE                                CR4_SMX_ENABLE_BIT
%define CR4_FSGSBASE                            CR4_FSGSBASE_ENABLE_BIT
%define CR4_PCIDE                               CR4_PCID_ENABLE_BIT
%define CR4_OSXSAVE                             CR4_XSAVE_PROCESSOR_EXTENDED_STATES
%define CR4_KL                                  CR4_KEY_LOCKER_ENABLE_BIT
%define CR4_SMEP                                CR4_SMEP_ENABLE_BIT
%define CR4_SMAP                                CR4_SMAP_ENABLE_BIT
%define CR4_PKE                                 CR4_ENABLE_PROTECTION_KEYS_USER
%define CR4_CET                                 CR4_CONTROL_FLOW_ENFORCEMENT_TECHNOLOGY
%define CR4_PKS                                 CR4_ENABLE_PROTECTION_KEYS_SUPERVISOR
%define CR4_UINTR                               CR4_USER_INTERRUPTS_ENABLE_BIT

;cr8 register
%define CR8_TASK_PRIORITY_LEVEL                 (15 << 0)

%define CR8_TPL                                 CR8_TASK_PRIORITY_LEVEL

;EFER register
%define EFER_ADDRESS                            0xC0000080
%define EFER_SYSTEM_CALL_EXTENSION              (1 << 0)
%define EFER_LONG_MODE_ENABLE                   (1 << 8)
%define EFER_LONG_MODE_ACTIVE                   (1 << 10)
%define EFER_NO_EXECUTE_ENABLE                  (1 << 11)
%define EFER_SECURE_VIRTUAL_MACHINE_ENABLE      (1 << 12)
%define EFER_LONG_MODE_SEGMENT_LIMIT_ENABLE     (1 << 13)
%define EFER_FAST_FXSAVE_FXRSTOR                (1 << 14)
%define EFER_TRANSLATION_CACHE_EXTENSION        (1 << 15)
%define EFER_MCOMMIT_ENABLE                     (1 << 17)
%define EFER_INTERRUPTIBLE_WBINVD               (1 << 18)
%define EFER_UPPER_ADDRESS_IGNORE_ENABLE        (1 << 20)
%define EFER_AUTOMATIC_IBRS_ENABLE              (1 << 21)

%define EFER_SCE                                EFER_SYSTEM_CALL_EXTENSION
%define EFER_LME                                EFER_LONG_MODE_ENABLE
%define EFER_LMA                                EFER_LONG_MODE_ACTIVE
%define EFER_NXE                                EFER_NO_EXECUTE_ENABLE
%define EFER_SVME                               EFER_SECURE_VIRTUAL_MACHINE_ENABLE
%define EFER_LMSLE                              EFER_LONG_MODE_SEGMENT_LIMIT_ENABLE
%define EFER_FFXSR                              EFER_FAST_FXSAVE_FXRSTOR
%define EFER_TCE                                EFER_TRANSLATION_CACHE_EXTENSION
%define EFER_MCOMMIT                            EFER_MCOMMIT_ENABLE
%define EFER_INTWB                              EFER_INTERRUPTIBLE_WBINVD
%define EFER_UAIE                               EFER_UPPER_ADDRESS_IGNORE_ENABLE
%define EFER_AIBRSE                             EFER_AUTOMATIC_IBRS_ENABLE

;PML4E Table
;PML4E reference PDPTE
%define PML4E_LOW_PRESENT                       (1 << 0)
%define PML4E_LOW_READ_WRITE                    (1 << 1)
%define PML4E_LOW_USER_SUPERVISOR               (1 << 2)
%define PML4E_LOW_PAGE_LEVEL_WRITE_THROUGH      (1 << 3)
%define PML4E_LOW_PAGE_LEVEL_CACHE_DISABLE      (1 << 4)
%define PML4E_LOW_ACCESSED                      (1 << 5)
%define PML4E_LOW_PHYSICAL_ADDRESS              (0xFFFFF000)
%define PML4E_HIGH_PHYSICAL_ADDRESS             (0x000FFFFF)
%define PML4E_HIGH_EXECUTE_DISABLE              (1 << 31)

;PDPTE  - Page-directory-pointer table
;PDPTE 1GB
%define PDPTE_1GB_LOW_PRESENT                   (1 << 0)
%define PDPTE_1GB_LOW_READ_WRITE                (1 << 1)
%define PDPTE_1GB_LOW_USER_SUPREVISOR           (1 << 2)
%define PDPTE_1GB_LOW_PAGE_LEVEL_WRITE_THROUGH  (1 << 3)
%define PDPTE_1GB_LOW_PAGE_LEVEL_CACHE_DISABLE  (1 << 4)
%define PDPTE_1GB_LOW_ACCESSED                  (1 << 5)
%define PDPTE_1GB_LOW_DIRTY                     (1 << 6)
%define PDPTE_1GB_LOW_PAGE_SIZE                 (1 << 7)
%define PDPTE_1GB_LOW_GLOBAL                    (1 << 8)
%define PDPTE_1GB_LOW_PAGE_ATTRIBUTE_TABLE      (1 << 12)
%define PDPTE_1GB_LOW_PHYSICAL_ADDRESS          (0xC0000000)
%define PDPTE_1GB_HIGH_PHYSICAL_ADDRESS         (0x000FFFFF)
%define PDPTE_1GB_HIGH_EXECUTE_DISABLE          (1 << 31)

;PDPTE reference PDE
%define PDPTE_LOW_PRESENT                       (1 << 0)
%define PDPTE_LOW_READ_WRITE                    (1 << 1)
%define PDPTE_LOW_USER_SUPREVISOR               (1 << 2)
%define PDPTE_LOW_PAGE_LEVEL_WRITE_THROUGH      (1 << 3)
%define PDPTE_LOW_PAGE_LEVEL_CACHE_DISABLE      (1 << 4)
%define PDPTE_LOW_ACCESSED                      (1 << 5)
%define PDPTE_LOW_PHYSICAL_ADDRESS              (0xFFFFF000)
%define PDPTE_HIGH_PHYSICAL_ADDRESS             (0x000FFFFF)
%define PDPTE_HIGH_EXECUTE_DISABLE              (1 << 31)

;PDE    - Page Directory
;PDE 2MB Page
%define PDE_2MB_LOW_PRESENT                     (1 << 0)
%define PDE_2MB_LOW_READ_WRITE                  (1 << 1)
%define PDE_2MB_LOW_USER_SUPREVISOR             (1 << 2)
%define PDE_2MB_LOW_PAGE_LEVEL_WRITE_THROUGH    (1 << 3)
%define PDE_2MB_LOW_PAGE_LEVEL_CACHE_DISABLE    (1 << 4)
%define PDE_2MB_LOW_ACCESSED                    (1 << 5)
%define PDE_2MB_LOW_DIRTY                       (1 << 6)
%define PDE_2MB_LOW_PAGE_SIZE                   (1 << 7)
%define PDE_2MB_LOW_GLOBAL                      (1 << 8)
%define PDE_2MB_LOW_PAGE_ATTRIBUTE_TABLE        (1 << 12)
%define PDE_2MB_LOW_PHYSICAL_ADDRESS            (0xFFE00000)
%define PDE_2MB_HIGH_PHYSICAL_ADDRESS           (0x000FFFFF)
%define PDE_2MB_HIGH_EXECUTE_DISABLE            (1 << 31)

;PDE reference PTE
%define PDE_LOW_PRESENT                         (1 << 0)
%define PDE_LOW_READ_WRITE                      (1 << 1)
%define PDE_LOW_USER_SUPREVISOR                 (1 << 2)
%define PDE_LOW_PAGE_LEVEL_WRITE_THROUGH        (1 << 3)
%define PDE_LOW_PAGE_LEVEL_CACHE_DISABLE        (1 << 4)
%define PDE_LOW_ACCESSED                        (1 << 5)
%define PDE_LOW_PHYSICAL_ADDRESS                (0xFFFFF000)
%define PDE_HIGH_PHYSICAL_ADDRESS               (0x000FFFFF)
%define PDE_HIGH_EXECUTE_DISABLE                (1 << 31)

;PTE    - Page Table
%define PTE_LOW_PRESENT                         (1 << 0)
%define PTE_LOW_READ_WRITE                      (1 << 1)
%define PTE_LOW_USER_SUPREVISOR                 (1 << 2)
%define PTE_LOW_PAGE_LEVEL_WRITE_THROUGH        (1 << 3)
%define PTE_LOW_PAGE_LEVEL_CACHE_DISABLE        (1 << 4)
%define PTE_LOW_ACCESSED                        (1 << 5)
%define PTE_LOW_DIRTY                           (1 << 6)
%define PTE_LOW_PAGE_ATTRIBUTE_TABLE            (1 << 7)
%define PTE_LOW_GLOBAL                          (1 << 8)
%define PTE_LOW_PHYSICAL_ADDRESS                (0xFFFFF000)
%define PTE_HIGH_PHYSICAL_ADDRESS               (0x000FFFFF)
%define PTE_HIGH_EXECUTE_DISABLE                (1 << 31)
