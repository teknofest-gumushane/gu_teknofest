abstract interface class ProjectRepository {
  Future<void> softDeleteProject(String id);
  Future<void> restoreProject(String id);
}
