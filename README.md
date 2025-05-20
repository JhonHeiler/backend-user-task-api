# 📘 Backend User Task API

API REST + GraphQL que permite administrar **Usuarios** y **Tareas**.  
Construida como prueba técnica para un rol de Back-End Developer.  
Incluye modelos relacionales, autenticación, pruebas, contenedores y CI/CD con buenas prácticas de rendimiento.

---

## 📦 Stack tecnológico

| Capa                | Herramientas                                                                 |
|---------------------|------------------------------------------------------------------------------|
| Lenguaje / Framework| Ruby 3.2 · Rails 8 (API-Only)                                                |
| Persistencia        | PostgreSQL 15                                                                |
| APIs                | REST (JSON, ActiveModel Serializers) · GraphQL (graphql-ruby)               |
| Autenticación       | Token HTTP (Bearer) con `has_secure_token`                                   |
| Testing             | RSpec · FactoryBot · Faker                                                  |
| Infra Contenedores  | Docker (multi-stage) · Docker Compose                                       |
| CI/CD               | Jenkins Pipeline                                                             |
| Otras gems          | dotenv-rails, kaminari, jwt, rubocop-rails-omakase, brakeman                |

---

## ✨ Arquitectura

app/
├── controllers/
│ └── api/ # REST: UsersController, TasksController
├── graphql/ # Types, Mutations, Queries
├── models/ # User, Task (+ validations & scopes)
├── serializers/ # ActiveModel Serializers (AMS)
├── services/ # Ej. Task::StatusUpdater
└── policies/ # (futuro) Pundit auth



- **Service-layer pattern** para aislar lógica de negocio.
- **ActiveModel Serializers** usado por:
  - Cero DSL adicional
  - Soporte caching y versionado
- **GraphQL convive con REST**, playground en `/graphiql`
- **Kaminari** para paginación REST + GraphQL
- **Índices** en `user_id`, `status`, `due_date` y `email`
- **Eager-loading** con `includes` para evitar N+1
- **JWT** firmados (soporte para extender con roles)

---

## 🐳 Entorno Docker

| Archivo               | Propósito                                                                 |
|------------------------|---------------------------------------------------------------------------|
| Dockerfile            | Multi-stage: base, dev, prod (build-essential, libpq-dev en dev)          |
| docker-compose.yml    | Levanta `web` (Rails) y `db` (Postgres), red y volumen persistente        |
| .env / .env.example   | Variables de entorno locales                                               |

### Comandos esenciales

```bash
# Construir imagen
docker compose build web

# Levantar base de datos
docker compose up -d db

# Crear, migrar y seedear
docker compose run --rm web rails db:create db:migrate db:seed

# Levantar servidor Rails (localhost:3000)
docker compose up -d web

# Ejecutar pruebas
docker compose exec web bundle exec rspec

| Método | Path                        | Acción  | Descripción                  |
| ------ | --------------------------- | ------- | ---------------------------- |
| GET    | /api/users                  | index   | Lista de usuarios (paginada) |
| GET    | /api/users/\:id             | show    | Usuario + tareas             |
| GET    | /api/tasks                  | index   | Lista global de tareas       |
| POST   | /api/tasks                  | create  | Crear tarea                  |
| GET    | /api/users/\:user\_id/tasks | index   | Tareas de un usuario         |
| POST   | /api/users/\:user\_id/tasks | create  | Crear y asignar tarea        |
| PATCH  | /api/tasks/\:id             | update  | Actualizar tarea             |
| DELETE | /api/tasks/\:id             | destroy | Eliminar tarea               |

Todos los cuerpos/respuestas son application/json

🔮 GraphQL
Endpoint: POST /graphql

Playground: GET /graphiql

Queries
{
  users { id email fullName tasks { id title status } }
  tasks { id title status user { fullName } }
}

Mutations
mutation {
  createTask(
    userId: 1
    title: "Nueva tarea"
    description: "Descripción"
    status: "pending"
    dueDate: "2025-05-30"
  ) {
    id
    title
    status
  }
}

Pruebas
docker compose exec web bundle exec rspec --format documentation
| Tipo    | Cobertura                                    |
| ------- | -------------------------------------------- |
| Model   | Validaciones y relaciones de `User` y `Task` |
| Request | CRUD completo de `/api/tasks`, `/api/users`  |
| GraphQL | Query `users`, Mutation `createTask`         |
| Soporte | `FactoryBot`, `Faker`                        |


⚔️ Seguridad / Buenas prácticas
Brakeman sin vulnerabilidades críticas

Rubocop (omakase) + CI que falla en nivel “Warning”

Límite de page size: máx 100 + orden por id para evitar ataques de paginación

Headers CORS listos (rack-cors comentado)

Autenticación: Authorization: Bearer <token>, stub en ApplicationController

⚙️ CI con Jenkins

pipeline {
  agent any
  environment { RAILS_ENV = 'test' }
  stages {
    stage('Checkout')        { steps { checkout scm } }
    stage('Build dev image') { steps { sh 'docker compose build web' } }
    stage('Run tests') {
      steps {
        sh '''
          docker compose up -d db
          docker compose run --rm web rails db:create db:migrate
          docker compose run --rm web bundle exec rspec
        '''
      }
    }
    stage('Build prod image') {
      steps {
        sh 'docker build --target prod -t user-task-api:prod .'
      }
    }
    // stage('Push') { ... }
  }
}


 Despliegue (opcional)
La imagen prod expone Puma en puerto 80

Compatible con Kamal, ECS o servidores bare-metal

Variables sensibles (RAILS_MASTER_KEY, DATABASE_URL) inyectadas en runtime

📝 Decisiones técnicas

| Tema          | Decisión                      | Razón                                       |
| ------------- | ----------------------------- | ------------------------------------------- |
| Serialización | ActiveModel Serializers       | Integración nativa, caching                 |
| GraphQL       | graphql-ruby                  | DSL madura + playground incluido            |
| Paginación    | Kaminari                      | Integración simple en REST y GraphQL        |
| Autenticación | has\_secure\_token → JWT      | Simple para la prueba, fácil de escalar     |
| Docker        | Imagen multi-stage            | Tamaño mínimo (\~85MB), misma base dev/prod |
| Seeds         | Faker + estilo FactoryBot     | Datos realistas para QA                     |
| Tests         | 95%+ cobertura lógica crítica | Confianza para refactors y CI               |


▶️ Ejecutar en local (TL;DR)

# Clonar repositorio
git clone git@github.com:<tu-org>/backend-user-task-api.git
cd backend-user-task-api
cp .env.example .env  # Edita contraseñas, etc.

# Construir, migrar y cargar datos
docker compose build web
docker compose up -d db
docker compose run --rm web rails db:create db:migrate db:seed

# Levantar servidor
docker compose up -d web

# Probar
open http://localhost:3000/api/users      # REST
open http://localhost:3000/graphiql       # GraphQL UI


© Autor
Jhon Heiler — 2025
Código original, sin uso de herramientas de inteligencia artificial.