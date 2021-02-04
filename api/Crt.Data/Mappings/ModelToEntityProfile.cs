using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.District;
using Crt.Model.Dtos.Element;
using Crt.Model.Dtos.FinTarget;
using Crt.Model.Dtos.Note;
using Crt.Model.Dtos.Permission;
using Crt.Model.Dtos.Project;
using Crt.Model.Dtos.QtyAccmp;
using Crt.Model.Dtos.Region;
using Crt.Model.Dtos.Role;
using Crt.Model.Dtos.RolePermission;
using Crt.Model.Dtos.ServiceArea;
using Crt.Model.Dtos.Tender;
using Crt.Model.Dtos.User;
using Crt.Model.Dtos.UserRole;

namespace Crt.Data.Mappings
{
    public class ModelToEntityProfile : Profile
    {
        public ModelToEntityProfile()
        {
            SourceMemberNamingConvention = new LowerUnderscoreNamingConvention();
            DestinationMemberNamingConvention = new PascalCaseNamingConvention();

            CreateMap<PermissionDto, CrtPermission>();

            CreateMap<RoleDto, CrtRole>();
            CreateMap<RoleCreateDto, CrtRole>();
            CreateMap<RoleUpdateDto, CrtRole>();
            CreateMap<RoleSearchDto, CrtRole>();
            CreateMap<RoleDeleteDto, CrtRole>();

            CreateMap<RolePermissionDto, CrtRolePermission>();

            CreateMap<UserDto, CrtSystemUser>();
            CreateMap<UserCreateDto, CrtSystemUser>();
            CreateMap<UserCurrentDto, CrtSystemUser>();
            CreateMap<UserSearchDto, CrtSystemUser>();
            CreateMap<UserUpdateDto, CrtSystemUser>();
            CreateMap<UserDeleteDto, CrtSystemUser>();

            CreateMap<UserRoleDto, CrtUserRole>();

            CreateMap<CodeLookupDto, CrtCodeLookup>();

            CreateMap<CrtRegionUser, RegionUserDto>();
            CreateMap<CrtServiceArea, ServiceAreaDto>();
            CreateMap<CrtRegion, RegionDto>();
            CreateMap<CrtRegionDistrict, RegionDistrictDto>();
            CreateMap<CrtDistrict, DistrictDto>();

            CreateMap<ProjectDto, CrtProject>();
            CreateMap<ProjectCreateDto, CrtProject>();
            CreateMap<ProjectUpdateDto, CrtProject>();
            CreateMap<ProjectDeleteDto, CrtProject>();

            CreateMap<NoteDto, CrtNote>();
            CreateMap<NoteCreateDto, CrtNote>();

            CreateMap<ElementDto, CrtElement>();

            CreateMap<FinTargetDto, CrtFinTarget>();

            CreateMap<QtyAccmpDto, CrtQtyAccmp>();

            CreateMap<TenderDto, CrtTender>();
        }
    }
}
