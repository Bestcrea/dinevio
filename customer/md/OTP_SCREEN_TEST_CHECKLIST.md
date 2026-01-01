# OTP Verification Screen - Test Checklist

## ✅ Implementation Summary

**File Modified:**
- `customer/lib/auth/otp_verification_screen.dart` (complete refactor)

**Key Features:**
- ✅ AppBar with back arrow, no title
- ✅ Centered content with title/subtitle
- ✅ 6-digit OTP input using Pinput package
- ✅ Error text below OTP
- ✅ Resend section with countdown timer (00:45 format)
- ✅ Bottom sticky "Verify" button with loading state
- ✅ Keyboard handling (SafeArea + viewInsets)
- ✅ Responsive design (textScaleFactor up to 1.5)
- ✅ Haptic feedback on error/success

---

## 🧪 Test Checklist

### 1. Visual Layout
- [ ] AppBar shows back arrow on left, no title
- [ ] Title "Enter verification code" is centered, bold, 32-36px
- [ ] Subtitle shows masked phone number: "+212 XX XX XX XX"
- [ ] OTP input shows 6 boxes horizontally aligned
- [ ] Each box is square/rounded (radius 10-12px), height ~56px
- [ ] Active box has primary color border (violet #7E57C2)
- [ ] Resend section shows "Didn't receive the code?" text
- [ ] Countdown timer displays in "00:45" format
- [ ] "Verify" button is full-width, height 58-60px, radius 16-18px

### 2. OTP Input Behavior
- [ ] First box auto-focuses on screen load
- [ ] Typing a digit moves focus to next box automatically
- [ ] Only numeric keyboard appears
- [ ] Can paste 6-digit code (fills all boxes)
- [ ] Can delete digits (backspace works)
- [ ] Active box has violet border, others have grey border

### 3. Error Handling
- [ ] Error text is hidden by default
- [ ] Entering wrong code shows red error text below OTP
- [ ] Error text says "Invalid code. Please try again."
- [ ] Error clears when user starts typing again
- [ ] OTP boxes show red border on error (errorPinTheme)

### 4. Resend Functionality
- [ ] Timer starts at 60 seconds (00:60)
- [ ] Timer counts down: 00:59, 00:58, ... 00:01, 00:00
- [ ] "Resend code" button is disabled while timer > 0
- [ ] "Resend code" becomes clickable when timer reaches 00:00
- [ ] Clicking "Resend code" shows loading spinner
- [ ] After resend, new code is sent and timer resets to 60s
- [ ] OTP input clears after resend
- [ ] Focus returns to first OTP box after resend

### 5. Verify Button
- [ ] Button is disabled until all 6 digits are entered
- [ ] Button enables when 6 digits are entered
- [ ] Clicking "Verify" shows loading spinner inside button
- [ ] Button text "Verify" is replaced by spinner during loading
- [ ] Button stays disabled during verification
- [ ] On success: navigates back with result
- [ ] On error: shows error message, button re-enables

### 6. Keyboard Handling
- [ ] Tapping outside OTP boxes dismisses keyboard
- [ ] Opening keyboard doesn't hide "Verify" button
- [ ] Button remains visible above keyboard
- [ ] SafeArea and viewInsets properly handle keyboard

### 7. Responsive Design
- [ ] Test on small screen (320px width):
  - [ ] No overflow warnings
  - [ ] All elements visible and accessible
  - [ ] OTP boxes scale appropriately
- [ ] Test with textScaleFactor 1.5:
  - [ ] No text overflow
  - [ ] Layout remains stable
  - [ ] Buttons and inputs properly sized

### 8. Edge Cases
- [ ] App goes to background during countdown:
  - [ ] Timer resumes correctly when app returns
  - [ ] Time remaining is accurate
- [ ] Network error during verify:
  - [ ] Error message displayed
  - [ ] Button re-enables
  - [ ] User can retry
- [ ] Network error during resend:
  - [ ] Error message displayed
  - [ ] Resend button re-enables
  - [ ] Timer state preserved

### 9. Haptic Feedback (Optional)
- [ ] Error triggers medium haptic feedback
- [ ] Success triggers light haptic feedback

### 10. Navigation
- [ ] Back arrow returns to previous screen
- [ ] Successful verification returns to caller with `result: true`
- [ ] Auto-verification (if enabled) works correctly

---

## 🚀 How to Test

### Step 1: Navigate to OTP Screen
1. Launch app
2. Go through onboarding → Phone login
3. Enter phone number and tap "Next"
4. OTP screen should appear

### Step 2: Test OTP Input
```bash
# Test auto-focus
- Screen loads → First box should be focused

# Test auto-advance
- Type "1" → Focus moves to box 2
- Type "2" → Focus moves to box 3
- Continue until all 6 digits entered

# Test paste
- Copy "123456" → Paste → All boxes should fill
```

### Step 3: Test Wrong Code
```bash
# Enter wrong code (e.g., "000000")
- Tap "Verify"
- Should see red error text: "Invalid code. Please try again."
- OTP boxes should show red border
- Start typing → Error should clear
```

### Step 4: Test Resend
```bash
# Wait for timer
- Watch countdown: 00:60 → 00:00
- "Resend code" should become clickable
- Tap "Resend code"
- Should see loading spinner
- Timer should reset to 00:60
- OTP input should clear
- First box should auto-focus
```

### Step 5: Test Keyboard
```bash
# Open keyboard
- Tap on OTP input
- Keyboard opens
- "Verify" button should remain visible above keyboard

# Dismiss keyboard
- Tap outside OTP boxes
- Keyboard should dismiss
```

### Step 6: Test Small Screen
```bash
# Run on small device or emulator
flutter run -d <device> --device-width=320

# Verify:
- No overflow warnings in console
- All elements visible
- Buttons accessible
```

### Step 7: Test Text Scaling
```bash
# Enable large text in device settings
Settings → Display → Font Size → Largest

# Verify:
- No text overflow
- Layout remains stable
- OTP boxes properly sized
```

---

## 📝 Expected Behavior

### Phone Number Formatting
- Input: `+212612345678`
- Output: `+212 XX XX 5678`

### Timer Format
- 60 seconds → `00:60`
- 45 seconds → `00:45`
- 5 seconds → `00:05`
- 0 seconds → `00:00` (then "Resend code" appears)

### Button States
- **Disabled:** Grey background, not clickable (when < 6 digits or loading)
- **Enabled:** Violet background, clickable (when 6 digits entered)
- **Loading:** Spinner replaces text, button disabled

---

## 🐛 Known Issues / Notes

- **Auto-verify on completion:** Currently disabled (commented out in `onCompleted`). Can be enabled if desired.
- **Haptic feedback:** Requires device with haptic support. Gracefully fails on devices without it.

---

## ✅ Sign-off

**Developer:** [Your Name]  
**Date:** 2024-12-27  
**Status:** ✅ Ready for QA Testing

