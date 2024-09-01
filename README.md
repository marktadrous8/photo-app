# Photo App Task

A Flutter application that displays a list of photos fetched from a remote API. The app supports pagination, lazy loading, sorting, and filtering by album ID.

## Features

- Fetch and display photos from a remote API
- Pagination with lazy loading (loads more photos as the user scrolls)
- Sort photos by album ID or title
- Filter photos by album ID
- Clear applied filters to return to the default view
- Scroll to  top feature with a floating action button
  
## Project preview
![ScreenRecording2024-09-01at3 06 55AM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/833f28a0-b7d9-43e5-87cb-1f7636b06ff2)


## Project Structure

The project follows the SOLID principles and a clean architecture pattern:

```plaintext
lib/
|-- core/
|   |-- error/
|   |-- result/
|
|-- data/
|   |-- models/
|   |-- repositories/
|   |-- data_sources/
|
|-- domain/
|   |-- entities/
|   |-- repositories/
|   |-- usecases/
|
|-- presentation/
|   |-- pages/
|   |-- providers/
|   |-- widgets/


