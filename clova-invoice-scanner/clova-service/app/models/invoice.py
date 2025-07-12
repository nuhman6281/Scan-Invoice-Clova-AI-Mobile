"""
Invoice processing models and data structures
"""

from typing import List, Optional, Dict, Any
from pydantic import BaseModel, Field
from datetime import datetime

class InvoiceItem(BaseModel):
    """Individual item from invoice"""
    name: str
    price: float
    quantity: int = 1
    total: Optional[float] = None
    category: Optional[str] = None
    confidence: Optional[float] = None

class ProcessingOptions(BaseModel):
    """Options for invoice processing"""
    confidence_threshold: float = 0.7
    use_fallback: bool = True
    extract_text_only: bool = False
    language: str = "en"

class InvoiceRequest(BaseModel):
    """Request model for invoice processing"""
    image_data: Optional[str] = None  # Base64 encoded image
    image_url: Optional[str] = None
    options: ProcessingOptions = ProcessingOptions()

class InvoiceResponse(BaseModel):
    """Response model for invoice processing"""
    success: bool
    scan_id: Optional[str] = None
    items: List[InvoiceItem] = []
    total_amount: Optional[float] = None
    confidence_score: Optional[float] = None
    processing_time_ms: int = 0
    model_used: Optional[str] = None
    metadata: Dict[str, Any] = {}
    error: Optional[str] = None

class ProcessingStatus(BaseModel):
    """Processing status information"""
    status: str  # "pending", "processing", "completed", "failed"
    progress: float = 0.0
    message: Optional[str] = None
    estimated_time: Optional[int] = None 