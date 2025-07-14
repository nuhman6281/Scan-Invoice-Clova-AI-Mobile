# 🍩 Quick Demo Reference Card

## 🎯 **For Real OCR Results - Use These Links:**

### **1. CORD (Document Parsing) - Best for Receipts**

**🔗 Link**: https://huggingface.co/spaces/naver-clova-ix/donut-base-finetuned-cord-v2
**📝 What it does**: Extracts items, prices, totals from receipts/invoices
**✅ Real output**: `{"menu": [{"nm": "Coffee", "price": "5.00"}], "total": {"total_price": "10.00"}}`

### **2. RVL-CDIP (Document Classification)**

**🔗 Link**: https://huggingface.co/spaces/nielsr/donut-rvlcdip
**📝 What it does**: Classifies document types (invoice, letter, form, etc.)
**✅ Real output**: `{"class": "invoice"}`

### **3. DocVQA (Question Answering)**

**🔗 Link**: https://huggingface.co/spaces/nielsr/donut-docvqa
**📝 What it does**: Answers questions about document content
**✅ Real output**: `{"answer": "The total amount is $25.50"}`

## 🚀 **How to Use (3 Simple Steps):**

1. **Click the link** above
2. **Wait 30-60 seconds** for the demo to load
3. **Upload your image** and get real AI results!

## 📸 **Test with Your Sample Images:**

- `misc/sample_image_cord_test_receipt_00004.png` → Use with CORD demo
- `misc/sample_image_donut_document.png` → Use with RVL-CDIP demo

## ⚡ **Pro Tips:**

- **Be patient** - demos take time to load
- **Use clear images** - better quality = better results
- **Try different images** - test various document types
- **Check JSON output** - structured data is extracted

## 🎉 **Why These Work:**

- ✅ **No setup required** - just click and use
- ✅ **Real AI processing** - actual OCR and understanding
- ✅ **Pre-configured** - all compatibility issues solved
- ✅ **Instant results** - no model loading delays

---

**🎯 Start Here**: https://huggingface.co/spaces/naver-clova-ix/donut-base-finetuned-cord-v2
