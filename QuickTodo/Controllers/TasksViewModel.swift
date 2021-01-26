import Foundation
import RxSwift
import RxDataSources
import Action

struct TasksViewModel {
  typealias TaskSection = AnimatableSectionModel<String, TaskItem>

  let sceneCoordinator: SceneCoordinatorType
  let taskService: TaskServiceType

  var sectionedItems: Observable<[TaskSection]> {
    return self.taskService.tasks()
      .map { results in
        let dueTasks = results
          .filter("checked == nil")
          .sorted(byKeyPath: "added", ascending: false)

        let doneTasks = results
          .filter("checked != nil")
          .sorted(byKeyPath: "checked", ascending: false)

        return [ TaskSection(model: "Due Tasks", items: dueTasks.toArray()),
                 TaskSection(model: "Done Tasks", items: doneTasks.toArray())
        ]
      }
  }

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
