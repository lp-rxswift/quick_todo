import Foundation
import RxSwift
import RxDataSources
import Action

struct TasksViewModel {
  typealias TaskSection = AnimatableSectionModel<String, TaskItem>

  let sceneCoordinator: SceneCoordinatorType
  let taskService: TaskServiceType

  init(taskService: TaskServiceType, coordinator: SceneCoordinatorType) {
    self.taskService = taskService
    self.sceneCoordinator = coordinator
  }

  func onToggle(task: TaskItem) -> CocoaAction {
    return CocoaAction {
      return self.taskService.toggle(task: task).map { _ in }
    }
  }

  func onDelete(task: TaskItem) -> CocoaAction {
    return CocoaAction {
      return self.taskService.delete(task: task)
    }
  }

  func onUpdateTitle(task: TaskItem) -> Action<String, Void> {
    return Action { newTitle in
      return self.taskService.update(task: task, title: newTitle).map { _ in }
    }
  }
}
