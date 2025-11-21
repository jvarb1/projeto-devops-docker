from fastapi import FastAPI, HTTPException, Depends
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db, engine, Base
from app.models import Task
from app.schemas import TaskCreate, TaskResponse, TaskUpdate
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="API de Tarefas",
    description="API CRUD para gerenciamento de tarefas",
    version="1.0.0"
)

@app.on_event("startup")
async def startup_event():
    Base.metadata.create_all(bind=engine)

@app.get("/")
async def root():
    return {
        "message": "API de Tarefas - CRUD",
        "status": "running",
        "docs": "/docs"
    }

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "task-api"
    }

@app.post("/tasks", response_model=TaskResponse, status_code=201)
async def create_task(task: TaskCreate, db: Session = Depends(get_db)):
    try:
        db_task = Task(
            title=task.title,
            description=task.description,
            status=task.status
        )
        db.add(db_task)
        db.commit()
        db.refresh(db_task)
        logger.info(f"Tarefa criada: {db_task.id}")
        return db_task
    except Exception as e:
        logger.error(f"Erro ao criar tarefa: {str(e)}")
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Erro ao criar tarefa: {str(e)}")

@app.get("/tasks", response_model=List[TaskResponse])
async def list_tasks(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    try:
        tasks = db.query(Task).offset(skip).limit(limit).all()
        logger.info(f"Total de tarefas retornadas: {len(tasks)}")
        return tasks
    except Exception as e:
        logger.error(f"Erro ao listar tarefas: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Erro ao listar tarefas: {str(e)}")

@app.get("/tasks/{task_id}", response_model=TaskResponse)
async def get_task(task_id: int, db: Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Tarefa não encontrada")
    return task

@app.put("/tasks/{task_id}", response_model=TaskResponse)
async def update_task(task_id: int, task_update: TaskUpdate, db: Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Tarefa não encontrada")
    
    try:
        if task_update.title is not None:
            task.title = task_update.title
        if task_update.description is not None:
            task.description = task_update.description
        if task_update.status is not None:
            task.status = task_update.status
        
        db.commit()
        db.refresh(task)
        logger.info(f"Tarefa atualizada: {task_id}")
        return task
    except Exception as e:
        logger.error(f"Erro ao atualizar tarefa: {str(e)}")
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Erro ao atualizar tarefa: {str(e)}")

@app.delete("/tasks/{task_id}", status_code=204)
async def delete_task(task_id: int, db: Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Tarefa não encontrada")
    
    try:
        db.delete(task)
        db.commit()
        logger.info(f"Tarefa deletada: {task_id}")
        return None
    except Exception as e:
        logger.error(f"Erro ao deletar tarefa: {str(e)}")
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Erro ao deletar tarefa: {str(e)}")

