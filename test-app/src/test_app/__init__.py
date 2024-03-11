from fastapi import FastAPI
from .views import router

__all__ = ('create_app', )

def create_app():
    app = FastAPI()

    app.include_router(router)

    return app