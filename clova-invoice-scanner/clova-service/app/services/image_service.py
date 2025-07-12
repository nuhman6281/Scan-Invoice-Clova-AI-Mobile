"""
Image processing and file handling service
"""

import os
import uuid
import base64
import aiofiles
from pathlib import Path
from typing import Optional
from fastapi import UploadFile
import structlog

from app.config import settings

logger = structlog.get_logger()

class ImageService:
    """Service for handling image uploads and processing"""
    
    def __init__(self):
        self.upload_dir = Path(settings.UPLOAD_DIR)
        self.upload_dir.mkdir(parents=True, exist_ok=True)
    
    async def save_upload(self, file: UploadFile) -> str:
        """Save uploaded file to disk"""
        try:
            # Generate unique filename
            file_extension = Path(file.filename).suffix if file.filename else ".jpg"
            filename = f"{uuid.uuid4()}{file_extension}"
            file_path = self.upload_dir / filename
            
            # Save file
            async with aiofiles.open(file_path, 'wb') as f:
                content = await file.read()
                await f.write(content)
            
            logger.info(f"Saved uploaded file: {file_path}")
            return str(file_path)
            
        except Exception as e:
            logger.error(f"Failed to save uploaded file: {e}")
            raise
    
    async def save_from_request(self, request) -> str:
        """Save image from request (base64 or URL)"""
        try:
            if request.image_data:
                # Handle base64 image
                return await self._save_base64_image(request.image_data)
            elif request.image_url:
                # Handle URL image (placeholder for now)
                raise NotImplementedError("URL image processing not implemented yet")
            else:
                raise ValueError("No image data provided")
                
        except Exception as e:
            logger.error(f"Failed to save image from request: {e}")
            raise
    
    async def _save_base64_image(self, base64_data: str) -> str:
        """Save base64 encoded image to disk"""
        try:
            # Remove data URL prefix if present
            if base64_data.startswith('data:image/'):
                base64_data = base64_data.split(',')[1]
            
            # Decode base64
            image_data = base64.b64decode(base64_data)
            
            # Generate filename
            filename = f"{uuid.uuid4()}.jpg"
            file_path = self.upload_dir / filename
            
            # Save file
            async with aiofiles.open(file_path, 'wb') as f:
                await f.write(image_data)
            
            logger.info(f"Saved base64 image: {file_path}")
            return str(file_path)
            
        except Exception as e:
            logger.error(f"Failed to save base64 image: {e}")
            raise
    
    async def cleanup_temp_file(self, file_path: str):
        """Clean up temporary file"""
        try:
            if os.path.exists(file_path):
                os.remove(file_path)
                logger.info(f"Cleaned up temp file: {file_path}")
        except Exception as e:
            logger.error(f"Failed to cleanup temp file {file_path}: {e}")
    
    def validate_file(self, file: UploadFile) -> bool:
        """Validate uploaded file"""
        if not file.content_type.startswith('image/'):
            return False
        
        if file.filename:
            extension = Path(file.filename).suffix.lower()
            if extension not in settings.ALLOWED_EXTENSIONS:
                return False
        
        return True 