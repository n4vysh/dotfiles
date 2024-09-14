/* Copyright 2024 n4vysh
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include QMK_KEYBOARD_H
#include "version.h"

#define MT_LALT LALT_T(KC_TAB)
#define MT_RCTL RCTL_T(KC_ESC)
#define TD_LFN TD(_TD_LFN)
#define TO_INS TO(INSERT)

#define A_LEFT LALT(KC_LEFT)
#define A_RGHT LALT(KC_RGHT)
#define A_BTN1 LALT(KC_BTN1)
#define C_BTN1 RCTL(KC_BTN1)
#define C_A RCTL(KC_A)
#define C_C RCTL(KC_C)
#define C_R RCTL(KC_R)
#define C_V RCTL(KC_V)
#define C_X RCTL(KC_X)
#define C_Y RCTL(KC_Y)
#define C_Z RCTL(KC_Z)
#define S_TAB S(KC_TAB)

enum layers {
  INSERT,
  MOUSE,
};

typedef struct {
  bool is_press_action;
  int state;
} tap;

enum td_count {
  SINGLE_TAP,
  SINGLE_HOLD,
  DOUBLE_TAP,
  DOUBLE_HOLD,
};

enum td_name {
  _TD_LFN,
};

int cur_dance(tap_dance_state_t *state);

void tdlf_finished(tap_dance_state_t *state, void *user_data);
void tdlf_reset(tap_dance_state_t *state, void *user_data);

tap_dance_action_t tap_dance_actions[] = {
    [_TD_LFN] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, tdlf_finished, tdlf_reset),
};

enum combos {
  KL_ENT,
  UI_LBRC,
  IO_RBRC,
  OP_BSLS,
  N_89_EQL,
  N_90_BSPC,
  AS_LEFT,
  SD_DOWN,
  WE_UP,
  DF_RGHT
};

const uint16_t PROGMEM kl_combo[] = {KC_K, KC_L, COMBO_END};
const uint16_t PROGMEM ui_combo[] = {KC_U, KC_I, COMBO_END};
const uint16_t PROGMEM io_combo[] = {KC_I, KC_O, COMBO_END};
const uint16_t PROGMEM op_combo[] = {KC_O, KC_P, COMBO_END};
const uint16_t PROGMEM n_89_combo[] = {KC_8, KC_9, COMBO_END};
const uint16_t PROGMEM n_90_combo[] = {KC_9, KC_0, COMBO_END};
const uint16_t PROGMEM as_combo[] = {KC_A, KC_S, COMBO_END};
const uint16_t PROGMEM sd_combo[] = {KC_S, KC_D, COMBO_END};
const uint16_t PROGMEM we_combo[] = {KC_W, KC_E, COMBO_END};
const uint16_t PROGMEM df_combo[] = {KC_D, KC_F, COMBO_END};

combo_t key_combos[] = {
    [KL_ENT] = COMBO(kl_combo, KC_ENT),
    [UI_LBRC] = COMBO(ui_combo, KC_LBRC),
    [IO_RBRC] = COMBO(io_combo, KC_RBRC),
    [OP_BSLS] = COMBO(op_combo, KC_BSLS),
    [N_89_EQL] = COMBO(n_89_combo, KC_EQL),
    [N_90_BSPC] = COMBO(n_90_combo, KC_BSPC),
    [AS_LEFT] = COMBO(as_combo, KC_LEFT),
    [SD_DOWN] = COMBO(sd_combo, KC_DOWN),
    [WE_UP] = COMBO(we_combo, KC_UP),
    [DF_RGHT] = COMBO(df_combo, KC_RGHT),
};

// clang-format off
// editorconfig-checker-disable
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [INSERT] = LAYOUT(
    KC_GRV,  KC_1,    KC_2,    KC_3,    KC_4,    KC_5,                         KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_MINS,
    KC_TAB,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                         KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_LBRC,
    XXXXXXX, KC_A,    KC_S,    KC_D,    KC_F,    KC_G,                         KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT,
    SC_LSPO, KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                         KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH, SC_RSPC,
                                                 TD_LFN,  MT_LALT,    KC_SPC,  MT_RCTL
  ),
  [MOUSE] = LAYOUT(
    KC_F11,  KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,                        KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F12,
    XXXXXXX, XXXXXXX, KC_W,    KC_BTN3, C_R,     XXXXXXX,                      C_Y,     A_LEFT,  TO_INS,  A_RGHT,  S_TAB,   XXXXXXX,
    XXXXXXX, C_A,     KC_MS_L, KC_WH_D, KC_WH_U, KC_MS_R,                      KC_WH_L, KC_MS_D, KC_MS_U, KC_WH_R, XXXXXXX, XXXXXXX,
    _______, C_Z,     C_X,     C_C,     C_V,     XXXXXXX,                      KC_TAB,  KC_HOME, KC_END,  KC_BSPC, KC_ENT,  _______,
                                                 KC_BTN2, A_BTN1,     C_BTN1,  KC_BTN1
  ),
};
// editorconfig-checker-enable
// clang-format on

// LED
layer_state_t layer_state_set_user(layer_state_t state) {
  STATUS_LED_1(false);
  STATUS_LED_2(false);
  STATUS_LED_3(false);
  STATUS_LED_4(false);

  uint8_t layer = get_highest_layer(state);
  switch (layer) {
  case INSERT:
    break;
  case MOUSE:
    STATUS_LED_2(true);
    STATUS_LED_4(true);
    break;
  default:
    break;
  }

  return state;
}

// Tap Dance
int cur_dance(tap_dance_state_t *state) {
  if (state->count == 1) {
    if (!state->pressed) {
      return SINGLE_TAP;
    } else {
      return SINGLE_HOLD;
    }
  } else if (state->count == 2) {
    if (!state->pressed) {
      return DOUBLE_TAP;
    } else {
      return DOUBLE_HOLD;
    }
  } else
    return 8;
}

// TD_LFN
static tap tdlf_tap_state = {.is_press_action = true, .state = 0};

void tdlf_finished(tap_dance_state_t *state, void *user_data) {
  tdlf_tap_state.state = cur_dance(state);
  switch (tdlf_tap_state.state) {
  case SINGLE_TAP:
    if (layer_state_is(INSERT)) {
      layer_move(MOUSE);
    }
    break;
  case SINGLE_HOLD:
    register_code(KC_LGUI);
    break;
  }
}

void tdlf_reset(tap_dance_state_t *state, void *user_data) {
  if (tdlf_tap_state.state == SINGLE_HOLD) {
    unregister_code(KC_LGUI);
  }

  tdlf_tap_state.state = 0;
}

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  case QK_TAP_DANCE ... QK_TAP_DANCE_MAX:
    return 275;
  default:
    return TAPPING_TERM;
  }
}
