# Reciplease
Project 10 of the OpenClassrooms "iOS Developer" training

## Introduction:

Reciplease is a recipes app that aims at helping the user find a list of recipes according to a list of ingredients :

* User types its ingredients and hit the Search button
* Recipes will be fetched accordingly and displayed in a list
* User will be able to see the recipe details when selecting one
* Recipe can be saved to favorites hitting the top-right start button 

## Frameworks and librairies:

* Alamofire
* CoreData
* XCTest
* Kingfisher

## APIs:

This app uses the following APIs :
* Edamam

## Getting started:

To test this application, you need to use API keys for yhe API's.

In supporting files's folder, you need to create a file ApiKey.swift.
It should contain the following informations :

```
// MARK: - List of API Key

let url = "https://api.edamam.com/api/recipes/v2"
let appKey = "your App Key"
let appId = "your App ID"
```

## ScreenShots:
![Screenshots Reciplease](https://user-images.githubusercontent.com/55231455/183084532-e41cb05d-cc0a-4b93-acc5-1329d41f810f.png)
