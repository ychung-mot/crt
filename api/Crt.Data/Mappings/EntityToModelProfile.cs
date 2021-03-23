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
using Crt.Model.Dtos.Project;
using Crt.Model.Dtos.FinTarget;
using Crt.Model.Dtos.Element;
using Crt.Model.Dtos.QtyAccmp;
using Crt.Model.Dtos.Tender;
using Crt.Model.Dtos.Segments;
using Crt.Model.Dtos.Ratio;

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
            CreateMap<CrtSystemUser, UserManagerDto>();

            CreateMap<AdAccount, AdAccountDto>();

            CreateMap<CrtUserRole, UserRoleDto>();

            CreateMap<CrtCodeLookup, CodeLookupDto>();

            CreateMap<CrtRegionUser, RegionUserDto>();
            CreateMap<CrtServiceArea, ServiceAreaDto>();
            CreateMap<CrtRegion, RegionDto>();
            CreateMap<CrtRegionDistrict, RegionDistrictDto>();
            CreateMap<CrtDistrict, DistrictDto>();

            CreateMap<CrtProject, ProjectDto>()
                .ForMember(x => x.Notes, opt => opt.MapFrom(x => x.CrtNotes));

            CreateMap<CrtProject, ProjectCreateDto>();
            CreateMap<CrtProject, ProjectUpdateDto>();
            CreateMap<CrtProject, ProjectDeleteDto>();
            CreateMap<CrtProject, ProjectSearchDto>()
                .ForMember(x => x.RegionNumber, opt => opt.MapFrom(x => x.Region.RegionNumber))
                .ForMember(x => x.RegionName, opt => opt.MapFrom(x => x.Region.RegionName));
            CreateMap<CrtProject, ProjectPlanDto>()
                .ForMember(x => x.FinTargets, opt => opt.MapFrom(x => x.CrtFinTargets));
            CreateMap<CrtProject, ProjectTenderDto>()
                .ForMember(x => x.Tenders, opt => opt.MapFrom(x => x.CrtTenders))
                .ForMember(x => x.QtyAccmps, opt => opt.MapFrom(x => x.CrtQtyAccmps));
            CreateMap<CrtNote, NoteDto>()
                .ForMember(x => x.UserId, opt => opt.MapFrom(x => x.AppCreateUserid))
                .ForMember(x => x.NoteDate, opt => opt.MapFrom(x => x.AppCreateTimestamp));
            CreateMap<CrtProject, ProjectLocationDto>()
                .ForMember(x => x.Ratios, opt => opt.MapFrom(x => x.CrtRatios))
                .ForMember(x => x.Segments, opt => opt.MapFrom(x => x.CrtSegments));

            CreateMap<CrtNote, NoteCreateDto>();

            CreateMap<CrtElement, ElementDto>();

            CreateMap<CrtFinTarget, FinTargetDto>();
            CreateMap<CrtFinTarget, FinTargetListDto>();

            CreateMap<CrtQtyAccmp, QtyAccmpDto>();
            CreateMap<CrtQtyAccmp, QtyAccmpListDto>();

            CreateMap<CrtTender, TenderDto>();
            CreateMap<CrtTender, TenderListDto>();

            CreateMap<CrtSegment, SegmentDto>();
            CreateMap<CrtSegment, SegmentCreateDto>();
            CreateMap<CrtSegment, SegmentUpdateDto>();
            CreateMap<CrtSegment, SegmentListDto>();

            CreateMap<CrtRatio, RatioDto>();
            CreateMap<CrtRatio, RatioCreateDto>();
            CreateMap<CrtRatio, RatioListDto>();
            CreateMap<CrtRatio, RatioUpdateDto>();

            CreateMap<CrtCodeLookup, CodeLookupListDto>();
            CreateMap<CrtCodeLookup, CodeLookupCreateDto>();
            CreateMap<CrtCodeLookup, CodeLookupUpdateDto>();
        }
    }
}
