using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services.Base;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.Project;
using Crt.Model.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface IProjectService
    {
        Task<PagedDto<ProjectSearchDto>> GetProjectsAsync(string? regions,
            string searchText, bool? isInProgress, string projectManagerIds,
            int pageSize, int pageNumber, string orderBy, string direction);
        Task<ProjectDto> GetProjectAsync(decimal projectId);
        Task<(decimal projectId, Dictionary<string, List<string>> errors)> CreateProjectAsync(ProjectCreateDto project);
        Task<(bool NotFound, Dictionary<string, List<string>> Errors)> UpdateProjectAsync(ProjectUpdateDto project);
        Task<(bool NotFound, Dictionary<string, List<string>> Errors)> DeleteProjectAsync(ProjectDeleteDto project);
        Task<ProjectTenderDto> GetProjectTenderAsync(decimal projectId);
        Task<ProjectPlanDto> GetProjectPlanAsync(decimal projectId);
    }

    public class ProjectService : CrtServiceBase, IProjectService
    {
        private IProjectRepository _projectRepo;
        private IUserRepository _userRepo;

        public ProjectService(CrtCurrentUser currentUser,IFieldValidatorService validator, IUnitOfWork unitOfWork,
             IProjectRepository projectRepo, IUserRepository userRepo)
            : base(currentUser, validator, unitOfWork)
        {
            _projectRepo = projectRepo;
            _userRepo = userRepo;
        }

        public async Task<PagedDto<ProjectSearchDto>> GetProjectsAsync(string? regions,
            string searchText, bool? isInProgress, string projectManagerIds,
            int pageSize, int pageNumber, string orderBy, string direction)
        {
            //limitted to user regions
            var filteredRegions = regions.ToDecimalArray().Where(x => _currentUser.UserInfo.RegionIds.Contains(x)).ToArray();

            return await _projectRepo.GetProjectsAsync(filteredRegions, searchText, isInProgress, projectManagerIds.ToDecimalArray(),
                pageSize, pageNumber, orderBy, direction);
        }

        public async Task<ProjectDto> GetProjectAsync(decimal projectId)
        {
            return await _projectRepo.GetProjectAsync(projectId);
        }

        public async Task<(decimal projectId, Dictionary<string, List<string>> errors)> CreateProjectAsync(ProjectCreateDto project)
        {
            project.TrimStringFields();

            var errors = new Dictionary<string, List<string>>();

            _validator.Validate(Entities.Project, project, errors);

            await ValidateProject(project, errors);

            if (errors.Count > 0)
            {
                return (0, errors);
            }

            var crtProject = await _projectRepo.CreateProjectAsync(project);

            _unitOfWork.Commit();

            return (crtProject.ProjectId, errors);
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> Errors)> UpdateProjectAsync(ProjectUpdateDto project)
        {
            project.TrimStringFields();

            var crtProject = await _projectRepo.GetProjectAsync(project.ProjectId);

            if (crtProject == null)
            {
                return (true, null);
            }

            var errors = new Dictionary<string, List<string>>();

            _validator.Validate(Entities.Project, project, errors);

            await ValidateProject(project, errors);

            if (errors.Count > 0)
            {
                return (false, errors);
            }

            await _projectRepo.UpdateProjectAsync(project);

            _unitOfWork.Commit();

            return (false, errors);
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> Errors)> DeleteProjectAsync(ProjectDeleteDto project)
        {
            var crtProject = await _projectRepo.GetProjectAsync(project.ProjectId);

            if (crtProject == null)
            {
                return (true, null);
            }

            var errors = new Dictionary<string, List<string>>();

            if (!_currentUser.UserInfo.RegionIds.Contains(crtProject.RegionId))
            {
                errors.AddItem(Fields.RegionId, $"Invalid or unauthorized region ID [{crtProject.RegionId}]");
            }

            await _projectRepo.DeleteProjectAsync(project);

            _unitOfWork.Commit();

            return (false, errors);
        }

        private async Task ValidateProject(ProjectSaveDto project, Dictionary<string, List<string>> errors)
        {
            if (!_currentUser.UserInfo.RegionIds.Contains(project.RegionId))
            {
                errors.AddItem(Fields.RegionId, $"Invalid region ID [{project.RegionId}]");
            }

            var managers = await _userRepo.GetManagersAsync();
            if (project.ProjectMgrId != null && !managers.Any(x => x.SystemUserId == project.ProjectMgrId))
            {
                errors.AddItem(Fields.ProjectMgrId, $"Invalid project manager ID [{project.ProjectMgrId}]");
            }

            var projectId = project.GetType() == typeof(ProjectUpdateDto) ? ((ProjectUpdateDto)project).ProjectId : 0M;

            if (await _projectRepo.ProjectNumberAlreadyExists(projectId, project.ProjectNumber, project.RegionId))
            {
                errors.AddItem(Fields.ProjectNumber, $"Project Number [{project.ProjectNumber}] already exists");
            }
        }

        public async Task<ProjectTenderDto> GetProjectTenderAsync(decimal projectId)
        {
            return await _projectRepo.GetProjectTenderAsync(projectId);
        }

        public async Task<ProjectPlanDto> GetProjectPlanAsync(decimal projectId)
        {
            return await _projectRepo.GetProjectPlanAsync(projectId);
        }
    }
}
