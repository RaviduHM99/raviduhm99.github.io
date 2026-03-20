---
title: 2. Introduction to React.js
description: >-
  Learn the fundamentals of React.js, a powerful JavaScript library for building user interfaces. This guide covers components, JSX, and state management for beginners.
author: ravidu
date: 2025-03-08 10:00:00 -0500
categories: [Blogging, Frontend]
tags: [react javascript]
pin: false
blog: true
image:
  path: /assets/img/external/thumbnail.png
  alt: Thumbnail
---

## Understanding React Components

React is built on the concept of reusable components. Each component is a JavaScript function or class that returns JSX (JavaScript XML), which describes what the UI should look like.

### Basic Component Structure

```javascript
function Welcome() {
  return <h1>Hello, React!</h1>;
}
```

This is the simplest form of a React component. The component returns JSX, which looks like HTML but is actually JavaScript.

## Working with Props

Props are how you pass data from parent components to child components. They work similarly to function parameters.

### Example with Props

```javascript
function Greeting(props) {
  return <h1>Hello, {props.name}!</h1>;
}
```

## Next Steps

In the following tutorials, we'll dive deeper into hooks, state management, and building more complex applications.
