/* Copyright 2023 n4vysh
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
#define TD_RFN TD(_TD_RFN)
#define TO_INS TO(INSERT)

#define A_LEFT LALT(KC_LEFT)
#define A_RGHT LALT(KC_RGHT)
#define C_A RCTL(KC_A)
#define C_BSPC RCTL(KC_BSPC)
#define C_C RCTL(KC_C)
#define C_F RCTL(KC_F)
#define C_LEFT RCTL(KC_LEFT)
#define C_R RCTL(KC_R)
#define C_RGHT RCTL(KC_RGHT)
#define C_V RCTL(KC_V)
#define C_X RCTL(KC_X)
#define C_Y RCTL(KC_Y)
#define C_Z RCTL(KC_Z)
#define C_ENT RCTL(KC_ENT)
#define S_TAB S(KC_TAB)

enum layers {
  INSERT,
  NORMAL,
  MOUSE,
  FN,
  FN2,
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
  _TD_RFN,
};

int cur_dance(tap_dance_state_t *state);

void tdlf_finished(tap_dance_state_t *state, void *user_data);
void tdlf_reset(tap_dance_state_t *state, void *user_data);

void tdrf_finished(tap_dance_state_t *state, void *user_data);
void tdrf_reset(tap_dance_state_t *state, void *user_data);

tap_dance_action_t tap_dance_actions[] = {
    [_TD_LFN] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, tdlf_finished, tdlf_reset),
    [_TD_RFN] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, tdrf_finished, tdrf_reset),
};

enum custom_keycodes {
  M_HOME = SAFE_RANGE,
  M_END,
  M_LINE,
  M_DEL,
};

uint16_t QUEUE = XXXXXXX;

void LEADER(uint16_t keycode) { QUEUE = keycode; }

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [INSERT] = LAYOUT_moonlander(
    KC_GRV,  KC_1,    KC_2,    KC_3,    KC_4,    KC_5,    KC_BSLS,     KC_EQL,  KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_MINS,
    KC_TAB,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,    KC_LBRC,     KC_LBRC, KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_LBRC,
    XXXXXXX, KC_A,    KC_S,    KC_D,    KC_F,    KC_G,    KC_RBRC,     KC_RBRC, KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT,
    SC_LSPO, KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                          KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH, SC_RSPC,
    XXXXXXX, XXXXXXX, XXXXXXX, KC_LGUI, MT_LALT,          XXXXXXX,     XXXXXXX,          MT_RCTL, KC_APP,  XXXXXXX, XXXXXXX, XXXXXXX,
                                        KC_SPC,  TD_LFN,  XXXXXXX,     XXXXXXX, TD_RFN,  KC_SPC
  ),
  [NORMAL] = LAYOUT_moonlander(
    XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, M_END,   XXXXXXX, XXXXXXX,     XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, M_HOME,  XXXXXXX,
    XXXXXXX, XXXXXXX, C_RGHT,  XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,     XXXXXXX, C_C,     XXXXXXX, TO_INS,  XXXXXXX, C_V,     XXXXXXX,
    XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, M_LINE,  XXXXXXX,     XXXXXXX, KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, XXXXXXX, XXXXXXX,
    _______, XXXXXXX, M_DEL,   XXXXXXX, XXXXXXX, C_LEFT,                        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, C_F,     _______,
    XXXXXXX, XXXXXXX, XXXXXXX, _______, _______,          XXXXXXX,     XXXXXXX,          _______, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
                                        XXXXXXX, XXXXXXX, XXXXXXX,     XXXXXXX, XXXXXXX, XXXXXXX
  ),
  [MOUSE] = LAYOUT_moonlander(
    XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,     XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    XXXXXXX, XXXXXXX, KC_W,    KC_BTN3, C_R,     XXXXXXX, XXXXXXX,     XXXXXXX, C_Y,     A_LEFT,  TO_INS,  A_RGHT,  S_TAB,   XXXXXXX,
    XXXXXXX, C_A,     KC_MS_L, KC_WH_D, KC_WH_U, KC_MS_R, XXXXXXX,     XXXXXXX, KC_WH_L, KC_MS_D, KC_MS_U, KC_WH_R, XXXXXXX, XXXXXXX,
    _______, C_Z,     C_X,     C_C,     C_V,     XXXXXXX,                       KC_TAB,  KC_HOME, KC_END,  KC_BSPC, KC_ENT,  _______,
    XXXXXXX, XXXXXXX, XXXXXXX, _______, _______,          XXXXXXX,     XXXXXXX,          _______, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
                                        KC_BTN2, XXXXXXX, XXXXXXX,     XXXXXXX, XXXXXXX, KC_BTN1
  ),
  [FN] = LAYOUT_moonlander(
    XXXXXXX, KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   XXXXXXX,     XXXXXXX, KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  XXXXXXX,
    XXXXXXX, XXXXXXX, C_BSPC,  KC_END,  XXXXXXX, KC_F11,  XXXXXXX,     XXXXXXX, KC_F12,  XXXXXXX, KC_TAB,  XXXXXXX, KC_UP,   XXXXXXX,
    XXXXXXX, KC_HOME, XXXXXXX, KC_DEL,  KC_RGHT, XXXXXXX, XXXXXXX,     XXXXXXX, KC_BSPC, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    _______, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, KC_LEFT,                       KC_DOWN, KC_ENT,  XXXXXXX, XXXXXXX, XXXXXXX, _______,
    XXXXXXX, KC_BRID, KC_BRIU, _______, _______,          QK_BOOT,     QK_BOOT,          _______, KC_MUTE, KC_VOLD, KC_VOLU, XXXXXXX,
                                        XXXXXXX, XXXXXXX, XXXXXXX,     XXXXXXX, XXXXXXX, XXXXXXX
  ),
  [FN2] = LAYOUT_moonlander(
    XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,     XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,     XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,     XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    _______, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                       XXXXXXX, C_ENT,   XXXXXXX, XXXXXXX, XXXXXXX, _______,
    XXXXXXX, XXXXXXX, XXXXXXX, _______, _______,          XXXXXXX,     XXXXXXX,          _______, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
                                        XXXXXXX, XXXXXXX, XXXXXXX,     XXXXXXX, XXXXXXX, XXXXXXX
  ),
};
// clang-format on

// LED
layer_state_t layer_state_set_user(layer_state_t state) {
  ML_LED_1(false);
  ML_LED_2(false);
  ML_LED_3(false);
  ML_LED_4(false);
  ML_LED_5(false);
  ML_LED_6(false);

  uint8_t layer = get_highest_layer(state);
  switch (layer) {
  case NORMAL:
    ML_LED_1(true);
    ML_LED_4(true);
    break;
  case MOUSE:
    ML_LED_2(true);
    ML_LED_5(true);
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
    if (layer_state_is(INSERT)) {
      layer_on(FN);
    }
    break;
  case DOUBLE_HOLD:
    if (layer_state_is(INSERT)) {
      layer_on(FN2);
    }
    break;
  }
}

void tdlf_reset(tap_dance_state_t *state, void *user_data) {
  if (tdlf_tap_state.state == SINGLE_HOLD) {
    layer_off(FN);
  }
  if (tdlf_tap_state.state == DOUBLE_HOLD) {
    layer_off(FN2);
  }

  tdlf_tap_state.state = 0;
}

// TD_RFN
static tap tdrf_tap_state = {.is_press_action = true, .state = 0};

void tdrf_finished(tap_dance_state_t *state, void *user_data) {
  tdrf_tap_state.state = cur_dance(state);
  switch (tdrf_tap_state.state) {
  case SINGLE_TAP:
    if (layer_state_is(INSERT)) {
      layer_move(NORMAL);
    }
    break;
  case SINGLE_HOLD:
    if (layer_state_is(INSERT)) {
      layer_on(FN);
    }
    break;
  case DOUBLE_HOLD:
    if (layer_state_is(INSERT)) {
      layer_on(FN2);
    }
    break;
  }
}

void tdrf_reset(tap_dance_state_t *state, void *user_data) {
  if (tdrf_tap_state.state == SINGLE_HOLD) {
    layer_off(FN);
  }
  if (tdrf_tap_state.state == DOUBLE_HOLD) {
    layer_off(FN2);
  }

  tdrf_tap_state.state = 0;
}

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  case QK_TAP_DANCE ... QK_TAP_DANCE_MAX:
    return 275;
  default:
    return TAPPING_TERM;
  }
}

// Macros
bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  bool LSHIFTED = keyboard_report->mods & MOD_BIT(KC_LSFT);
  bool RSHIFTED = keyboard_report->mods & MOD_BIT(KC_RSFT);
  bool SHIFTED = LSHIFTED | RSHIFTED;

  switch (keycode) {
  case M_HOME:
    if (record->event.pressed) {
      SEND_STRING(SS_TAP(X_HOME));
    }
    break;
  case M_END:
    if (record->event.pressed) {
      if (SHIFTED) {
        unregister_code16(KC_LSFT);
        unregister_code16(KC_RSFT);
        SEND_STRING(SS_TAP(X_END));
      }
    }
    break;
  case M_LINE:
    if (record->event.pressed) {
      switch (QUEUE) {
      case XXXXXXX:
        if (SHIFTED) {
          LEADER(XXXXXXX);
          unregister_code16(KC_LSFT);
          unregister_code16(KC_RSFT);
          register_code16(KC_LCTL);
          register_code16(KC_RCTL);
          SEND_STRING(SS_TAP(X_END));
          unregister_code16(KC_LCTL);
          unregister_code16(KC_RCTL);
          break;
        } else {
          LEADER(M_LINE);
          break;
        }
      case M_LINE:
        LEADER(XXXXXXX);
        register_code16(KC_LCTL);
        register_code16(KC_RCTL);
        SEND_STRING(SS_TAP(X_HOME));
        unregister_code16(KC_LCTL);
        unregister_code16(KC_RCTL);
        break;
      }
    }
    break;
  case M_DEL:
    if (record->event.pressed) {
      if (SHIFTED) {
        SEND_STRING(SS_DOWN(X_BSPC));
        break;
      } else {
        SEND_STRING(SS_DOWN(X_DEL));
        break;
      }
    } else if (!record->event.pressed) {
      if (SHIFTED) {
        SEND_STRING(SS_UP(X_BSPC));
        break;
      } else {
        SEND_STRING(SS_UP(X_DEL));
        break;
      }
    }
    break;
  }
  return true;
};
