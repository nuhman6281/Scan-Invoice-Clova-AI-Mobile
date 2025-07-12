"""
Configuration settings for CLOVA AI Invoice Scanner Service
"""

import os
from typing import List
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    """Application settings"""
    
    # Server settings
    HOST: str = "0.0.0.0"
    PORT: int = 8000
    DEBUG: bool = True
    
    # CORS settings - use simple string for env var compatibility
    ALLOWED_ORIGINS_STR: str = "http://localhost:3000,http://localhost:3001,http://localhost:3002,http://192.168.1.113:3000,http://192.168.1.113:3001,http://192.168.1.113:3002"
    
    @property
    def ALLOWED_ORIGINS(self) -> List[str]:
        """Parse allowed origins from comma-separated string"""
        return [origin.strip() for origin in self.ALLOWED_ORIGINS_STR.split(",")]
    
    # File upload settings
    UPLOAD_DIR: str = "uploads"
    MAX_FILE_SIZE: int = 10 * 1024 * 1024  # 10MB
    ALLOWED_EXTENSIONS: List[str] = [".jpg", ".jpeg", ".png", ".webp"]
    
    # AI Model settings
    DONUT_MODEL_NAME: str = "naver-clova-ix/donut-base-finetuned-cord-v2"
    CONFIDENCE_THRESHOLD: float = 0.7
    USE_FALLBACK: bool = True
    
    # Processing settings
    MAX_PROCESSING_TIME: int = 60  # seconds
    BATCH_SIZE: int = 1
    
    # Logging
    LOG_LEVEL: str = "INFO"
    LOG_FORMAT: str = "json"
    
    class Config:
        env_file = ".env"
        case_sensitive = False

# Create settings instance
settings = Settings() 