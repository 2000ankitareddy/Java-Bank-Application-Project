pipeline {
 agent any

 stages {

 stage('Clone Repo'){
 steps{

 }
 }

 stage('Build WAR'){
 steps{
 sh 'mvn clean package'
 }
 }

 stage('Build Docker'){
 steps{
 sh 'docker build -t indigo-app .'
 }
 }

 stage('Run Container'){
 steps{
 sh 'docker run -d -p 8082:8080 indigo-app'
 }
 }

 }

}
