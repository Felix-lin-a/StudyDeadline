# StudyDeadline

StudyDeadline is an iOS application designed to help university students manage course assessment deadlines in one place. Students can create courses, add assessment deadlines, view upcoming deadlines, and mark assessments as complete or incomplete.

The application also integrates with iOS system features so that deadline information is available outside the main app.

## Domain Context

University students often manage multiple courses and assessment deadlines at the same time. Important information may be spread across learning management systems, course pages, websites, calendars, and personal notes.

StudyDeadline provides one place for students to organise their courses and assessment deadlines. The main stakeholder is a university student managing multiple subjects and assessment tasks.

## Main Features

- Create and view courses
- Add assessment deadlines to a course
- View upcoming deadlines on the dashboard
- Mark deadlines as complete or incomplete
- Store course and deadline data using Core Data
- Display an upcoming deadline using a Home Screen widget
- Share a webpage from Safari to StudyDeadline
- Save the shared source URL with a deadline
- Open the original source from a saved deadline

## Architecture

StudyDeadline follows an MVVM architecture with a Use Case and Repository layer.

The main structure is:

Views → ViewModels → Use Cases → Repository → Core Data

### Domain Models

The main domain models are:

- Course
- Deadline

### ViewModels

The application uses ViewModels to manage UI state and connect the user interface to the Use Case layer.

Examples include:

- CourseListViewModel
- CourseDetailViewModel
- DashboardViewModel

### Use Cases

Business operations are separated into Use Case structs:

- CreateCourseUseCase
- CreateDeadlineUseCase
- UpdateDeadlineStatusUseCase

These Use Cases contain domain rules and communicate with the Repository rather than accessing Core Data directly.

### Repository

DeadlineRepository defines the repository interface used by the Use Cases and ViewModels.

CoreDataDeadlineRepository provides the Core Data implementation.

This separation also allows MockDeadlineRepository to be used for unit testing without using the real Core Data store.

## Database Choice

StudyDeadline uses Core Data for persistent storage.

Core Data was chosen because course and deadline information is private user data that needs to be stored locally and accessed quickly. The application does not currently require users to share this information with other users or synchronise it between multiple accounts.

The data model contains related Course and Deadline entities. A course can contain multiple deadlines.

## System Extensions

### WidgetKit Widget

StudyDeadline includes a WidgetKit extension that displays the student's upcoming assessment deadline on the Home Screen.

The widget helps students check important deadline information without opening the main application.

It supports:

- Small widgets
- Medium widgets

The main application and widget communicate through an App Group shared container. When relevant deadline information changes, the application reloads the widget timeline so that the displayed information can be updated.

### Share Extension

StudyDeadline includes a Share Extension for receiving webpage URLs from other applications such as Safari.

For example, when a student finds assessment information on a course webpage, the webpage can be shared to StudyDeadline. The URL is passed through the App Group shared container and can then be attached to a new deadline.

The saved URL can later be opened from the deadline in StudyDeadline. This reduces the need to manually copy and paste links between applications.

## App Group

The application, Widget Extension, and Share Extension use the following App Group identifier:

`group.com.felixlina.StudyDeadline`

The App Group is used to share lightweight information between the main application and its extensions.

## Testing

The project includes unit tests for the Use Case and Repository layers.

Tests use MockDeadlineRepository instead of the real Core Data implementation.

The test suite covers successful operations and domain error cases, including:

- Creating a course
- Rejecting a course with a missing name
- Creating a deadline
- Rejecting invalid deadline input
- Updating deadline completion status
- Handling repository save failure

The project currently contains six unit tests.

## Setup Instructions

1. Open the StudyDeadline project in Xcode.
2. Select the StudyDeadline scheme.
3. Select an iOS Simulator.
4. Build and run the application.
5. Add a course and create assessment deadlines from the Courses tab.
6. Use the Dashboard to view upcoming deadlines.
7. Add the StudyDeadline widget to the Simulator Home Screen to view the upcoming deadline.
8. Open Safari in the Simulator and share a webpage to StudyDeadline to test the Share Extension.
9. The App Group identifier used by the main app and extensions is `group.com.felixlina.StudyDeadline`.
10. Run the StudyDeadlineTests test plan to execute the unit tests.

## Technologies

- Swift
- SwiftUI
- Core Data
- WidgetKit
- Share Extension
- App Groups
- XCTest
- MVVM
- Repository Pattern
- Use Case Layer
