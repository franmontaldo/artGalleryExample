<br />
<div align="center">
  <h3 align="center">Art Institute of Chicago App Example</h3>
  <p align="center">
    This app is an example developed for a job interview excersice. 
  </p>
</div>

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#external-dependencies">External Dependecies</a></li>
    <li><a href="#architecture">Architecture</a></li>
    <li><a href="#challenge-notes">Challenge Notes</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

## About The Project
This is a demonstration project developed as part of a job interview exercise. The app showcases a simple yet interactive interface that allows users to browse through a collection of artworks sourced from the Art Institute of Chicago's API. Users can view details about each artwork, including its title, description and some information about the artist. 

## Getting Started
### Installation
Clone the repo
   ```sh
   git clone https://github.com/your_username_/Project-Name.git
   ```

## External Dependencies
External Dependencies:

This project relies on two external dependencies: **Alamofire** and **Combine**. **Alamofire** is used for making **network requests** to fetch data from the Art Institute of Chicago's API, while **Combine** is utilized for handling asynchronous operations and managing **data flow** within the app. Both libraries were added to the project using **Swift Package Manager (SPM)**, a lightweight and easy-to-use dependency management tool provided by Apple. **I chose SPM** because it allows developers to seamlessly integrate **pre-compiled** libraries into their projects, offering a convenient alternative to other dependency management solutions like CocoaPods.

## Architecture

### Architecture & Design Pattern
The app is designed following clean architecture principles, with a clear separation of concerns between different layers. Notably, i opted not to include a repository layer, deeming it unnecessary for the scope of this project and though of as over-engineering. While this decision raised concerns for the fact a view model was receiving data from second API, i could effectively manage the models and view models accordingly. I used MVVM (Model-View-ViewModel) design pattern to ensure separation of concerns and facilitate unit testing.

### Modularization
Additionally, the project is modularized, with each module representing a distinct layer of the app's architecture. This modular approach not only helps prevent circular dependencies but also maintains a well-organized codebase. For the sake of convenience, I used Xcode native frameworks for modularization, though in an ideal scenario, Swift Package Manager (SPM) would be a preferred choice.

## Challenge notes
- I wanted to mention I used CoreData because of the inability to use Realm, given the fact that i could only add 2 dependencies.

## Contact
Francisco Montaldo - [LinkedIn](https://linkedin.com/in/franmontaldo/) - franmontaldo@gmail.com 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

