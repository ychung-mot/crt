using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Model;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.Permission;
using Crt.Model.Dtos.Role;
using Crt.Model.Dtos.RolePermission;
using Crt.Model.Dtos.User;
using Crt.Model.Dtos.UserRole;
using Crt.Model.Dtos.ServiceArea;
using Crt.Model.Dtos.Region;
using Crt.Model.Dtos.District;
using Crt.Model.Dtos.Note;

namespace Crt.Data.Mappings
{
    public class EntityToModelProfile : Profile
    {
        public EntityToModelProfile()
        {
            SourceMemberNamingConvention = new LowerUnderscoreNamingConvention();
            DestinationMemberNamingConvention = new PascalCaseNamingConvention();

            CreateMap<CrtPermission, PermissionDto>();
            CreateMap<CrtRole, RoleDto>();
            CreateMap<CrtRole, RoleCreateDto>();
            CreateMap<CrtRole, RoleUpdateDto>();
            CreateMap<CrtRole, RoleSearchDto>();
            CreateMap<CrtRole, RoleDeleteDto>();
            CreateMap<CrtRolePermission, RolePermissionDto>();

            CreateMap<CrtSystemUser, UserDto>();
            CreateMap<CrtSystemUser, UserCreateDto>();
            CreateMap<CrtSystemUser, UserCurrentDto>();
            CreateMap<CrtSystemUser, UserSearchDto>();
            CreateMap<CrtSystemUser, UserUpdateDto>();
            CreateMap<CrtSystemUser, UserDeleteDto>();

            CreateMap<AdAccount, AdAccountDto>();

            CreateMap<CrtUserRole, UserRoleDto>();

            CreateMap<CrtCodeLookup, CodeLookupDto>();

            CreateMap<CrtRegionUser, RegionUserDto>();
            CreateMap<CrtServiceArea, ServiceAreaDto>();
            CreateMap<CrtRegion, RegionDto>();
            CreateMap<CrtRegionDistrict, RegionDistrictDto>();
            CreateMap<CrtDistrict, DistrictDto>();

            CreateMap <CrtNote, NoteDto>()
                  .ForMember(x => x.UserId, opt => opt.MapFrom(x => x.AppCreateUserid))
                  .ForMember(x => x.NoteDate, opt => opt.MapFrom(x => x.AppCreateTimestamp));
        }
    }
}
