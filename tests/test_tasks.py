import pytest
from fastapi import status

def test_create_task(client):
    response = client.post(
        "/tasks",
        json={
            "title": "Tarefa de Teste",
            "description": "Descrição da tarefa de teste",
            "status": "pending"
        }
    )
    assert response.status_code == status.HTTP_201_CREATED
    data = response.json()
    assert data["title"] == "Tarefa de Teste"
    assert data["description"] == "Descrição da tarefa de teste"
    assert data["status"] == "pending"
    assert "id" in data
    assert "created_at" in data
    assert "updated_at" in data

def test_create_task_minimal(client):
    response = client.post(
        "/tasks",
        json={
            "title": "Tarefa Mínima"
        }
    )
    assert response.status_code == status.HTTP_201_CREATED
    data = response.json()
    assert data["title"] == "Tarefa Mínima"
    assert data["status"] == "pending"

def test_list_tasks_empty(client):
    response = client.get("/tasks")
    assert response.status_code == status.HTTP_200_OK
    assert response.json() == []

def test_list_tasks(client):
    client.post(
        "/tasks",
        json={"title": "Tarefa 1", "status": "pending"}
    )
    client.post(
        "/tasks",
        json={"title": "Tarefa 2", "status": "completed"}
    )
    
    response = client.get("/tasks")
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert len(data) == 2
    assert data[0]["title"] in ["Tarefa 1", "Tarefa 2"]
    assert data[1]["title"] in ["Tarefa 1", "Tarefa 2"]

def test_get_task(client):
    create_response = client.post(
        "/tasks",
        json={"title": "Tarefa para Obter", "status": "pending"}
    )
    task_id = create_response.json()["id"]
    
    response = client.get(f"/tasks/{task_id}")
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert data["id"] == task_id
    assert data["title"] == "Tarefa para Obter"
    assert data["status"] == "pending"

def test_get_task_not_found(client):
    response = client.get("/tasks/999")
    assert response.status_code == status.HTTP_404_NOT_FOUND
    assert "não encontrada" in response.json()["detail"].lower()

def test_update_task(client):
    create_response = client.post(
        "/tasks",
        json={"title": "Tarefa Original", "status": "pending"}
    )
    task_id = create_response.json()["id"]
    
    response = client.put(
        f"/tasks/{task_id}",
        json={"title": "Tarefa Atualizada", "status": "completed"}
    )
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert data["title"] == "Tarefa Atualizada"
    assert data["status"] == "completed"
    assert data["id"] == task_id

def test_update_task_partial(client):
    create_response = client.post(
        "/tasks",
        json={"title": "Tarefa Original", "status": "pending"}
    )
    task_id = create_response.json()["id"]
    
    response = client.put(
        f"/tasks/{task_id}",
        json={"status": "completed"}
    )
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert data["title"] == "Tarefa Original"
    assert data["status"] == "completed"

def test_update_task_not_found(client):
    response = client.put(
        "/tasks/999",
        json={"title": "Tarefa Inexistente"}
    )
    assert response.status_code == status.HTTP_404_NOT_FOUND

def test_delete_task(client):
    create_response = client.post(
        "/tasks",
        json={"title": "Tarefa para Deletar", "status": "pending"}
    )
    task_id = create_response.json()["id"]
    
    response = client.delete(f"/tasks/{task_id}")
    assert response.status_code == status.HTTP_204_NO_CONTENT
    
    get_response = client.get(f"/tasks/{task_id}")
    assert get_response.status_code == status.HTTP_404_NOT_FOUND

def test_delete_task_not_found(client):
    response = client.delete("/tasks/999")
    assert response.status_code == status.HTTP_404_NOT_FOUND

def test_root_endpoint(client):
    response = client.get("/")
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert "message" in data
    assert "status" in data

def test_health_endpoint(client):
    response = client.get("/health")
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert data["status"] == "healthy"
    assert data["service"] == "task-api"

