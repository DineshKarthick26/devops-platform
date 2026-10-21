from app import app

def test_home_endpoint():
    client = app.test_client()
    
    response = client.get("/")

    assert response.status_code == 200

    data = response.get_json()
    assert data["application"] == "Devops project"
    assert data["status"] == "running"

def test_health_endpoint():
    client = app.test_client()

    response = client.get("/health")