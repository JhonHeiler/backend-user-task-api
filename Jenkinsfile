pipeline {
  agent any
  stages {
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
      steps { sh 'docker build --target prod -t user-task-api:prod .' }
    }
  }
}
