/*    Benjamin DELPY `gentilkiwi`
http://blog.gentilkiwi.com
benjamin@gentilkiwi.com
Licence : http://creativecommons.org/licenses/by/3.0/fr/
*/
rule mimikatz
{
meta:
description        = “mimikatz”
author            = “Benjamin DELPY (gentilkiwi)”
tool_author        = “Benjamin DELPY (gentilkiwi)”
strings:
$exe_x86_1        = { 89 71 04 89 [0-3] 30 8d 04 bd }
$exe_x86_2        = { 89 79 04 89 [0-3] 38 8d 04 b5 }
$exe_x64_1        = { 4c 03 d8 49 [0-3] 8b 03 48 89 }
$exe_x64_2        = { 4c 8b df 49 [0-3] c1 e3 04 48 [0-3] 8b cb 4c 03 [0-3] d8 }
$dll_1            = {    c7 0? 00 00 01 00 [4-14] c7 0? 01 00 00 00 }
$dll_2            = { c7 0? 10 02 00 00 ?? 89 4? }
$sys_x86        = { a0 00 00 00 24 02 00 00 40 00 00 00 [0-4] b8 00 00 00 6c 02 00 00 40 00 00 00 }
$sys_x64        = { 88 01 00 00 3c 04 00 00 40 00 00 00 [0-4] e8 02 00 00 f8 02 00 00 40 00 00 00 }
condition:
(all of ($exe_x86_*)) or (all of ($exe_x64_*)) or (all of ($dll_*)) or (any of ($sys_*))
}
rule mimikatz_lsass_mdmp
{
meta:
description        = “LSASS minidump file for mimikatz”
author            = “Benjamin DELPY (gentilkiwi)”
strings:
$lsass            = “System32\\lsass.exe”    wide nocase
condition:
(uint32(0) == 0x504d444d) and $lsass
}
rule mimikatz_kirbi_ticket
{
meta:
description        = “KiRBi ticket for mimikatz”
author            = “Benjamin DELPY (gentilkiwi)”
strings:
$asn1            = { 76 82 ?? ?? 30 82 ?? ?? a0 03 02 01 05 a1 03 02 01 16 }
condition:
$asn1 at 0
}
rule wce
{
meta:
description        = “wce”
author            = “Benjamin DELPY (gentilkiwi)”
tool_author        = “Hernan Ochoa (hernano)”
strings:
$hex_legacy        = { 8b ff 55 8b ec 6a 00 ff 75 0c ff 75 08 e8 [0-3] 5d c2 08 00 }
$hex_x86        = { 8d 45 f0 50 8d 45 f8 50 8d 45 e8 50 6a 00 8d 45 fc 50 [0-8] 50 72 69 6d 61 72 79 00 }
$hex_x64        = { ff f3 48 83 ec 30 48 8b d9 48 8d 15 [0-16] 50 72 69 6d 61 72 79 00 }
condition:
any of them
}
