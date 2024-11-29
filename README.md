# Text Classification with Gemini and LangChain.dart

## Overview

This project demonstrates various text classification techniques using Google's Gemini AI and LangChain.dart. The repository contains multiple Dart scripts showcasing different approaches to text classification and sentiment analysis:

- `food_classification.dart`: Classifies recipes into categories
- `book_classification.dart`: Categorizes books by genre
- `zero_shot.dart`: Performs sentiment analysis without prior examples
- `fake_conversation.dart`: Uses few-shot learning for sentiment classification
- `few_shot.dart`: Another few-shot sentiment analysis example

## Prerequisites

- Google AI Studio API Key

## Setup

### Obtain Google AI Studio API Key

1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Create a new API key or use an existing one

### Set Environment Variable

#### macOS/Linux:
```bash
export GOOGLEAI_API_KEY='your_actual_api_key_here'
```

#### Windows (PowerShell):
```powershell
$env:GOOGLEAI_API_KEY='your_actual_api_key_here'
```

### Verify API Key Setup

#### macOS/Linux:
```bash
echo $GOOGLEAI_API_KEY
```

#### Windows PowerShell:
```powershell
$env:GOOGLEAI_API_KEY
```

## Running the Scripts

Each script demonstrates a different text classification technique. You can run them individually:

```bash
cd lib
```
Then:

```bash
dart run food_classification.dart
```
```bash
dart run book_classification.dart
```
```bash
dart run zero_shot.dart
```
```bash
dart run few_shot.dart
```
```bash
dart run fake_conversation.dart
```

## Scripts Explanation

### 1. Food Classification
Demonstrates classifying a recipe into predefined categories (Appetizer, Main, Dessert) using embedding similarity.

### 2. Book Classification
Shows genre classification of a book description by comparing embeddings with existing book examples.

### 3. Zero-Shot Sentiment Analysis
Performs sentiment analysis without prior examples, using a JSON-based structured output.

### 4. Few-Shot Sentiment Analysis
Uses a few example inputs to guide the model in sentiment classification.

### 5. Fake Conversation
Demonstrates sentiment analysis using a few-shot learning approach with a fake conversation.

## Important Notes

- Always keep your API key confidential
- Ensure you have an active internet connection
- The Gemini API has usage limits in its free tier

## Troubleshooting

- Check that your API key is correctly set
- Verify you have the latest versions of Dart and the required packages
- Ensure you're connected to the internet

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.