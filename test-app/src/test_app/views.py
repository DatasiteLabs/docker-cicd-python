from fastapi import APIRouter

from .models import Summation

__all__ = ('router', )

router = APIRouter()

@router.get("/add/{augend}/{addend}")
def hello(augend: int, addend: int) -> Summation:
    return Summation(augend=augend, addend=addend, sum=augend + addend)