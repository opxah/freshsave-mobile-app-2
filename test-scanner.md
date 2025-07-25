# Barcode Scanner Test Plan

## Test Cases

### 1. Basic Navigation Test
- [ ] App loads without errors
- [ ] User can log in with customer@test.com
- [ ] Scan tab is accessible
- [ ] No JSX errors in console

### 2. Manual Input Test
- [ ] Keyboard icon is visible
- [ ] Tapping keyboard icon opens manual input
- [ ] Text input field is focused
- [ ] Can enter numeric barcode
- [ ] Cancel button closes input
- [ ] Scan button processes barcode

### 3. Product Lookup Test
- [ ] Valid barcode returns product info
- [ ] Invalid barcode shows "Product Not Found"
- [ ] Product display shows at bottom
- [ ] Product image loads correctly
- [ ] Product name and brand display
- [ ] Score and rating display (if available)

### 4. Product Display Test
- [ ] Product card is clickable
- [ ] Tapping product navigates to detail
- [ ] Scan Again button resets state
- [ ] Product disappears after scan again

### 5. UI/UX Test
- [ ] Black background
- [ ] Scan frame with green corners
- [ ] Instructions text is readable
- [ ] Manual input modal is centered
- [ ] Product display has proper styling

### 6. Error Handling Test
- [ ] Empty barcode shows error
- [ ] Network errors are handled
- [ ] Invalid input is prevented

## Test Data
- Valid barcode: 1234567890123
- Invalid barcode: 9999999999999
- Empty input: ""
- Special characters: abc123

## Expected Results
- Manual input should work perfectly
- Product lookup should work
- UI should be clean and functional
- No JSX errors should occur 