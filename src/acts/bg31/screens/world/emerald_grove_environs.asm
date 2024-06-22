#define screen_id_emerald_grove_environs 4

.local
screen_data:
screen_background:
.asciz "~~¶█¶~~£££~£~~#▜▓▓▓▓"
.asciz "~~왓왓왓     ~£~##▝▀▜▓▓"
.asciz "~            ~~##▐▓▓"
.asciz "              ~##▐▓▓"
.asciz "~             ¶##▐█▓"
.asciz "~£           ~###▐▓▓"
.asciz "¶~~¶~£~~     ~#▗▂▟▓▓"
.asciz "~~£~¶¶~~£~~~ ~¶▐▓▓▓▓"
screen_title: .asciz "EmeraldGroveEnvirons"
screen_start_x: .db 13 ; 1-indexed since it's screen coordinates!
screen_start_y: .db 7
screen_interactables:
    DEFINE_INTERACTABLE to_crash_site, in_door, iflags_door, 8, 13
    DEFINE_INTERACTABLE to_blighted_village, in_door, iflags_door, 4, 1
    DEFINE_INTERACTABLE to_grove, in_door, iflags_door, 1, 4
    DEFINE_INTERACTABLE fight_1, in_door, iflags_door, 2, 6
    DEFINE_INTERACTABLE fight_2, in_door, iflags_door, 3, 2
    DEFINE_INTERACTABLE fight_3, in_door, iflags_door, 3, 3
    DEFINE_INTERACTABLE fight_4, in_door, iflags_door, 3, 4
    DEFINE_INTERACTABLE fight_5, in_door, iflags_door, 3, 5
    DEFINE_INTERACTABLE fight_6, in_door, iflags_door, 3, 6
    DEFINE_INTERACTABLE blank_10, 0, iflags_normal, 0, 0
screen_get_interaction_prompt: .dw get_interaction_prompt
screen_interact_callback: .dw on_interact
screen_menu_callback: .dw pause_menu

emerald_grove_environs::
    call check_goblins_at_the_gate

    ld hl, player_party
    ld a, (party_size)
    ld bc, screen_data
    call exploration_ui

    ret

get_interaction_prompt:
    ld hl, empty_prompt
    ret

on_interact:
    cp a, 0
    jp z,  exit_to_crash_site

    cp a, 1
    jp z, exit_to_blighted_village

    cp a, 2
    jp z, exit_to_grove

    ; everything else is the goblin fight trigger

    jp goblins_interact

exit_to_blighted_village:
    ld a, 2
    ld (screen_start_x), a

    ld a, 4
    ld (screen_start_y), a
    EXIT_EXPLORATION ec_door, screen_id_blighted_village
    ret

exit_to_crash_site:
    ld a, 13
    ld (screen_start_x), a

    ld a, 7
    ld (screen_start_y), a
    EXIT_EXPLORATION ec_door, screen_id_crash_site
    ret

exit_to_grove:
    ld a, 4
    ld (screen_start_x), a

    ld a, 2
    ld (screen_start_y), a

    EXIT_EXPLORATION ec_door, screen_id_emerald_grove
    ret

goblins_interact:
    ld a, 4
    ld (screen_start_x), a

    ld a, 4
    ld (screen_start_y), a

    call dialog_goblins_at_the_gate
    cp a, 0
    jp z, goblins_done

    EXIT_EXPLORATION ec_encounter, encounter_id_goblins_at_the_gate

goblins_done:
    ret

check_goblins_at_the_gate:
    ld a, (killed_goblins_at_the_gate)
    cp a, 0
    jp nz, clear_goblins

    ld a, (minthara_started_attack)
    cp a, 0
    jp nz, clear_goblins

    ret

clear_goblins:
    ld a, (fight_1_flags)
    and a, $7f
    ld (fight_1_flags), a
    ld (fight_2_flags), a
    ld (fight_3_flags), a
    ld (fight_4_flags), a
    ld (fight_5_flags), a
    ld (fight_6_flags), a

    ld a, " "
    ld hl, screen_background
    ld bc, 23
    add hl, bc
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a

    ld hl, screen_background
    ld bc, 3
    add hl, bc
    ld (hl), a

    ret

reset_emerald_grove_environs::
    RESET_SCREEN screen_data, 13, 7
    ld a, "왓"
    ld (screen_background + 23), a
    ld (screen_background + 24), a
    ld (screen_background + 25), a
    ret
.endlocal