# CLOVA Service Fixes Summary

## Overview

Applied the same fixes that worked in the root donut project to the clova-service to resolve model loading and compatibility issues.

## Changes Made

### 1. Updated `requirements.txt`

- Changed `transformers==4.35.0` to `transformers==4.25.1`
- Added `timm==0.5.4`
- Added `structlog==23.2.0`

### 2. Updated `real_clova_service.py`

- Added `ignore_mismatched_sizes=True` when loading the Donut model
- Changed task prompt from `<s_cord>` to `<s_cord-v2>`
- Updated parsing logic to handle both `<s_cord-v2>` and `<s_cord>` task prompts

### 3. Updated `app/services/clova_processor.py`

- Added `ignore_mismatched_sizes=True` when loading the Donut model
- Already had correct `<s_cord-v2>` task prompt

### 4. Updated `working_clova_service.py`

- Added `ignore_mismatched_sizes=True` when loading the Donut model
- Changed task prompt from `<s_cord>` to `<s_cord-v2>`
- Updated parsing logic to handle both task prompts

### 5. Updated `simple_main.py`

- Added `ignore_mismatched_sizes=True` when loading the Donut model
- No task prompt changes needed (uses direct generation)

### 6. Updated `test_donut.py`

- Added `ignore_mismatched_sizes=True` when loading the Donut model
- Already had correct `<s_cord-v2>` task prompt

### 7. Created `test_fixes.py`

- Test script to verify all fixes work correctly

## Key Fixes Applied

1. **Weight Mismatch Handling**: Added `ignore_mismatched_sizes=True` to all model loading calls
2. **Task Prompt Update**: Changed from `<s_cord>` to `<s_cord-v2>` for CORD-v2 model
3. **Compatible Versions**: Used transformers==4.25.1 and timm==0.5.4
4. **Backward Compatibility**: Parsing logic handles both old and new task prompts
5. **Robust JSON Parsing**: Added validation to handle non-numeric values (times, dates, headers) in extracted data
6. **Error Handling**: Improved error handling for malformed data and invalid price/quantity values

## Testing

Run the test script to verify fixes:

```bash
cd clova-invoice-scanner/clova-service
python test_fixes.py
```

## Expected Results

- Model should load without weight mismatch errors
- Processing should work with proper extraction
- Task prompt should be `<s_cord-v2>` for CORD-v2 model
- Backward compatibility maintained for old task prompts
- Robust parsing that handles various data formats and edge cases
- No crashes when encountering non-numeric values in extracted data
