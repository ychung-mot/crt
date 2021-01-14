using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

#nullable disable

namespace Crt.Data.Database.Entities
{
    public partial class AppDbContext : DbContext
    {
        public AppDbContext()
        {
        }

        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        public virtual DbSet<CrtCodeLookup> CrtCodeLookups { get; set; }
        public virtual DbSet<CrtCodeLookupHist> CrtCodeLookupHists { get; set; }
        public virtual DbSet<CrtDistrict> CrtDistricts { get; set; }
        public virtual DbSet<CrtPermission> CrtPermissions { get; set; }
        public virtual DbSet<CrtPermissionHist> CrtPermissionHists { get; set; }
        public virtual DbSet<CrtRegion> CrtRegions { get; set; }
        public virtual DbSet<CrtRegionDistrict> CrtRegionDistricts { get; set; }
        public virtual DbSet<CrtRegionDistrictHist> CrtRegionDistrictHists { get; set; }
        public virtual DbSet<CrtRegionUser> CrtRegionUsers { get; set; }
        public virtual DbSet<CrtRegionUserHist> CrtRegionUserHists { get; set; }
        public virtual DbSet<CrtRole> CrtRoles { get; set; }
        public virtual DbSet<CrtRoleHist> CrtRoleHists { get; set; }
        public virtual DbSet<CrtRolePermission> CrtRolePermissions { get; set; }
        public virtual DbSet<CrtRolePermissionHist> CrtRolePermissionHists { get; set; }
        public virtual DbSet<CrtServiceArea> CrtServiceAreas { get; set; }
        public virtual DbSet<CrtServiceAreaHist> CrtServiceAreaHists { get; set; }
        public virtual DbSet<CrtSystemUser> CrtSystemUsers { get; set; }
        public virtual DbSet<CrtSystemUserHist> CrtSystemUserHists { get; set; }
        public virtual DbSet<CrtUserRole> CrtUserRoles { get; set; }
        public virtual DbSet<CrtUserRoleHist> CrtUserRoleHists { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<CrtCodeLookup>(entity =>
            {
                entity.HasKey(e => e.CodeLookupId)
                    .HasName("CRT_CODE_LKUP_PK");

                entity.ToTable("CRT_CODE_LOOKUP");

                entity.HasComment("A range of lookup values used to decipher codes used in submissions to business legible values for reporting purposes.  As many code lookups share this table, views are available to join for reporting purposes.");

                entity.HasIndex(e => new { e.CodeSet, e.CodeValueNum, e.CodeName }, "CRT_CODE_LKUP_VAL_NUM_UC")
                    .IsUnique();

                entity.HasIndex(e => new { e.CodeSet, e.CodeValueText, e.CodeName }, "CRT_CODE_LKUP_VAL_TXT_UC")
                    .IsUnique();

                entity.Property(e => e.CodeLookupId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("CODE_LOOKUP_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_CODE_LKUP_ID_SEQ])")
                    .HasComment("Unique identifier for a record.");

                entity.Property(e => e.CodeName)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("CODE_NAME")
                    .HasComment("Display name or business name for a submission value.  These values are for display in analytical reporting.");

                entity.Property(e => e.CodeSet)
                    .HasMaxLength(20)
                    .IsUnicode(false)
                    .HasColumnName("CODE_SET")
                    .HasComment("Unique identifier for a group of lookup codes.  A database view is available for each group for use in analytics.");

                entity.Property(e => e.CodeValueFormat)
                    .HasMaxLength(12)
                    .IsUnicode(false)
                    .HasColumnName("CODE_VALUE_FORMAT")
                    .HasComment("Specifies if the code value is text or numeric.");

                entity.Property(e => e.CodeValueNum)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("CODE_VALUE_NUM")
                    .HasComment(" Numeric enumeration values provided in submissions.   These values are used for validating submissions and for display of CODE NAMES in analytical reporting.  Values must be unique per CODE SET.");

                entity.Property(e => e.CodeValueText)
                    .HasMaxLength(20)
                    .IsUnicode(false)
                    .HasColumnName("CODE_VALUE_TEXT")
                    .HasComment("Look up code values provided in submissions.   These values are used for validating submissions and for display of CODE NAMES in analytical reporting.  Values must be unique per CODE SET.");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasDefaultValueSql("((1))")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.DisplayOrder)
                    .HasColumnType("numeric(3, 0)")
                    .HasColumnName("DISPLAY_ORDER")
                    .HasComment("When displaying list of values, value can be used to present list in desired order.");

                entity.Property(e => e.EndDate)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE")
                    .HasComment("The latest date submissions will be accepted.");
            });

            modelBuilder.Entity<CrtCodeLookupHist>(entity =>
            {
                entity.HasKey(e => e.CodeLookupHistId)
                    .HasName("CRT_CODE__H_PK");

                entity.ToTable("CRT_CODE_LOOKUP_HIST");

                entity.HasIndex(e => new { e.CodeLookupHistId, e.EndDateHist }, "CRT_CODE__H_UK")
                    .IsUnique();

                entity.Property(e => e.CodeLookupHistId)
                    .HasColumnName("CODE_LOOKUP_HIST_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_CODE_LOOKUP_H_ID_SEQ])");

                entity.Property(e => e.CodeLookupId)
                    .HasColumnType("numeric(18, 0)")
                    .HasColumnName("CODE_LOOKUP_ID");

                entity.Property(e => e.CodeName)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("CODE_NAME");

                entity.Property(e => e.CodeSet)
                    .HasMaxLength(20)
                    .IsUnicode(false)
                    .HasColumnName("CODE_SET");

                entity.Property(e => e.CodeValueFormat)
                    .HasMaxLength(12)
                    .IsUnicode(false)
                    .HasColumnName("CODE_VALUE_FORMAT");

                entity.Property(e => e.CodeValueNum)
                    .HasColumnType("numeric(18, 0)")
                    .HasColumnName("CODE_VALUE_NUM");

                entity.Property(e => e.CodeValueText)
                    .HasMaxLength(20)
                    .IsUnicode(false)
                    .HasColumnName("CODE_VALUE_TEXT");

                entity.Property(e => e.ConcurrencyControlNumber).HasColumnName("CONCURRENCY_CONTROL_NUMBER");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID");

                entity.Property(e => e.DisplayOrder)
                    .HasColumnType("numeric(18, 0)")
                    .HasColumnName("DISPLAY_ORDER");

                entity.Property(e => e.EffectiveDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("EFFECTIVE_DATE_HIST")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.EndDate)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE");

                entity.Property(e => e.EndDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE_HIST");
            });

            modelBuilder.Entity<CrtDistrict>(entity =>
            {
                entity.HasKey(e => e.DistrictId)
                    .HasName("CRT_DISTRICT_PK");

                entity.ToTable("CRT_DISTRICT");

                entity.HasComment("Ministry Districts lookup values.");

                entity.HasIndex(e => new { e.DistrictNumber, e.DistrictName, e.EndDate }, "CRT_DIST_NO_NAME_UK")
                    .IsUnique();

                entity.Property(e => e.DistrictId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("DISTRICT_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_DIST_ID_SEQ])")
                    .HasComment("Unique identifier for district records");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasDefaultValueSql("((1))")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.DistrictName)
                    .IsRequired()
                    .HasMaxLength(40)
                    .IsUnicode(false)
                    .HasColumnName("DISTRICT_NAME")
                    .HasComment("The name of the District");

                entity.Property(e => e.DistrictNumber)
                    .HasColumnType("numeric(2, 0)")
                    .HasColumnName("DISTRICT_NUMBER")
                    .HasComment("Number assigned to represent the District");

                entity.Property(e => e.EndDate)
                    .HasColumnType("date")
                    .HasColumnName("END_DATE")
                    .HasComment("Date the entity ends or changes");
            });

            modelBuilder.Entity<CrtPermission>(entity =>
            {
                entity.HasKey(e => e.PermissionId)
                    .HasName("CRT_PERMISSION_PK");

                entity.ToTable("CRT_PERMISSION");

                entity.HasComment("Permission definition table for assignment to individual system users.");

                entity.Property(e => e.PermissionId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("PERMISSION_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_PERM_ID_SEQ])")
                    .HasComment("Unique identifier for a record");

                entity.Property(e => e.AppCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_CREATE_TIMESTAMP")
                    .HasComment("Date and time of record creation");

                entity.Property(e => e.AppCreateUserGuid)
                    .HasColumnName("APP_CREATE_USER_GUID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_CREATE_USERID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time of last record update");

                entity.Property(e => e.AppLastUpdateUserGuid)
                    .HasColumnName("APP_LAST_UPDATE_USER_GUID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.AppLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_LAST_UPDATE_USERID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasDefaultValueSql("((1))")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.Description)
                    .HasMaxLength(150)
                    .IsUnicode(false)
                    .HasColumnName("DESCRIPTION")
                    .HasComment("Description of a permission.");

                entity.Property(e => e.EndDate)
                    .HasColumnType("date")
                    .HasColumnName("END_DATE")
                    .HasComment("Date permission was deactivated");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("NAME")
                    .HasComment("Business name for a permission");
            });

            modelBuilder.Entity<CrtPermissionHist>(entity =>
            {
                entity.HasKey(e => e.PermissionHistId)
                    .HasName("CRT_PERMISSION_H_PK");

                entity.ToTable("CRT_PERMISSION_HIST");

                entity.HasComment("Permission definition table for assignment to individual system users.");

                entity.HasIndex(e => new { e.EndDateHist, e.PermissionHistId }, "CRT_PERM_H_UK")
                    .IsUnique();

                entity.Property(e => e.PermissionHistId)
                    .HasColumnName("PERMISSION_HIST_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_PERMISSION_H_ID_SEQ])");

                entity.Property(e => e.AppCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_CREATE_TIMESTAMP")
                    .HasComment("Date and time of record creation");

                entity.Property(e => e.AppCreateUserGuid)
                    .HasColumnName("APP_CREATE_USER_GUID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_CREATE_USERID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time of last record update");

                entity.Property(e => e.AppLastUpdateUserGuid)
                    .HasColumnName("APP_LAST_UPDATE_USER_GUID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.AppLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_LAST_UPDATE_USERID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.Description)
                    .HasMaxLength(150)
                    .IsUnicode(false)
                    .HasColumnName("DESCRIPTION")
                    .HasComment("Description of a permission.");

                entity.Property(e => e.EffectiveDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("EFFECTIVE_DATE_HIST")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.EndDate)
                    .HasColumnType("date")
                    .HasColumnName("END_DATE")
                    .HasComment("Date permission was deactivated");

                entity.Property(e => e.EndDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE_HIST");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("NAME")
                    .HasComment("Business name for a permission");

                entity.Property(e => e.PermissionId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("PERMISSION_ID")
                    .HasComment("Unique identifier for a record");
            });

            modelBuilder.Entity<CrtRegion>(entity =>
            {
                entity.HasKey(e => e.RegionId)
                    .HasName("CRT_REGION_PK");

                entity.ToTable("CRT_REGION");

                entity.HasComment("Ministry Region lookup values");

                entity.HasIndex(e => new { e.RegionNumber, e.RegionName, e.EndDate }, "CRT_REG_NO_NAME_UK")
                    .IsUnique();

                entity.Property(e => e.RegionId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("REGION_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_REG_ID_SEQ])")
                    .HasComment("Unique identifier for Ministry region");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasDefaultValueSql("((1))")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.EndDate)
                    .HasColumnType("date")
                    .HasColumnName("END_DATE")
                    .HasComment("Date the entity ends or changes");

                entity.Property(e => e.RegionName)
                    .IsRequired()
                    .HasMaxLength(40)
                    .IsUnicode(false)
                    .HasColumnName("REGION_NAME")
                    .HasComment("Name of the Ministry region");

                entity.Property(e => e.RegionNumber)
                    .HasColumnType("numeric(2, 0)")
                    .HasColumnName("REGION_NUMBER")
                    .HasComment("Number assigned to the Ministry region");
            });

            modelBuilder.Entity<CrtRegionDistrict>(entity =>
            {
                entity.HasKey(e => e.RegionDistrictId)
                    .HasName("CRT_REGION_DISTR_PK");

                entity.ToTable("CRT_REGION_DISTRICT");

                entity.HasComment("Ministry Region District lookup values");

                entity.HasIndex(e => new { e.EndDate, e.RegionId, e.DistrictId }, "CRT_REG_DIS_NO_NAME_UK")
                    .IsUnique();

                entity.Property(e => e.RegionDistrictId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("REGION_DISTRICT_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_REG_DIST_ID_SEQ])")
                    .HasComment("Unique identifier");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasDefaultValueSql("((1))")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.DistrictId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("DISTRICT_ID")
                    .HasComment("unique identifier for Ministry district");

                entity.Property(e => e.EndDate)
                    .HasColumnType("date")
                    .HasColumnName("END_DATE")
                    .HasComment("Date the entity ends or changes");

                entity.Property(e => e.RegionId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("REGION_ID")
                    .HasComment("unique identifier for Ministry region");

                entity.HasOne(d => d.District)
                    .WithMany(p => p.CrtRegionDistricts)
                    .HasForeignKey(d => d.DistrictId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("CRT_DISTRICT_CRT_REGION_DISTRICT");

                entity.HasOne(d => d.Region)
                    .WithMany(p => p.CrtRegionDistricts)
                    .HasForeignKey(d => d.RegionId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("CRT_REGION_CRT_REGION_DISTRICT");
            });

            modelBuilder.Entity<CrtRegionDistrictHist>(entity =>
            {
                entity.HasKey(e => e.RegionDistrictHistId)
                    .HasName("CRT_REGION_DISTR_H_PK");

                entity.ToTable("CRT_REGION_DISTRICT_HIST");

                entity.HasComment("Ministry Region lookup values");

                entity.HasIndex(e => new { e.RegionDistrictHistId, e.EndDateHist }, "CRT_REG_DIS_H_NO_NAME_UK")
                    .IsUnique();

                entity.Property(e => e.RegionDistrictHistId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("REGION_DISTRICT_HIST_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_REG_DIST_H_ID_SEQ])")
                    .HasComment("Unique identifier");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.DistrictId)
                    .HasColumnType("numeric(2, 0)")
                    .HasColumnName("DISTRICT_ID")
                    .HasComment("unique identifier for Ministry district");

                entity.Property(e => e.EffectiveDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("EFFECTIVE_DATE_HIST")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.EndDate)
                    .HasColumnType("date")
                    .HasColumnName("END_DATE")
                    .HasComment("Date the entity ends or changes");

                entity.Property(e => e.EndDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE_HIST");

                entity.Property(e => e.RegionDistrictId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("REGION_DISTRICT_ID")
                    .HasComment("Unique identifier");

                entity.Property(e => e.RegionId)
                    .HasColumnType("numeric(2, 0)")
                    .HasColumnName("REGION_ID")
                    .HasComment("unique identifier for Ministry region");
            });

            modelBuilder.Entity<CrtRegionUser>(entity =>
            {
                entity.HasKey(e => e.RegionUserId)
                    .HasName("CRT_REGION_USR_PK");

                entity.ToTable("CRT_REGION_USER");

                entity.HasComment("Association between USER and REGION defining which users can submit or access data.");

                entity.HasIndex(e => e.SystemUserId, "CRT_REGION_USER_FK_I");

                entity.Property(e => e.RegionUserId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("REGION_USER_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_REGION_USR_ID_SEQ])")
                    .HasComment("Unique identifier for REGION User");

                entity.Property(e => e.AppCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_CREATE_TIMESTAMP")
                    .HasComment("Date and time of record creation");

                entity.Property(e => e.AppCreateUserGuid)
                    .HasColumnName("APP_CREATE_USER_GUID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_CREATE_USERID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time of last record update");

                entity.Property(e => e.AppLastUpdateUserGuid)
                    .HasColumnName("APP_LAST_UPDATE_USER_GUID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.AppLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_LAST_UPDATE_USERID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasDefaultValueSql("((1))")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.EndDate)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE")
                    .HasComment("Date reflecting when a user can no longer transmit submissions.");

                entity.Property(e => e.RegionId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("REGION_ID")
                    .HasComment("identifier for REGION");

                entity.Property(e => e.SystemUserId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("SYSTEM_USER_ID")
                    .HasComment("Unique identifier of related user");

                entity.HasOne(d => d.Region)
                    .WithMany(p => p.CrtRegionUsers)
                    .HasForeignKey(d => d.RegionId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("CRT_REGION_CRT_REGION_USER");

                entity.HasOne(d => d.SystemUser)
                    .WithMany(p => p.CrtRegionUsers)
                    .HasForeignKey(d => d.SystemUserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("CRT_SYSTEM_USER_CRT_REGION_USER");
            });

            modelBuilder.Entity<CrtRegionUserHist>(entity =>
            {
                entity.HasKey(e => e.RegionUserHistId)
                    .HasName("CRT_REGION_U_H_PK");

                entity.ToTable("CRT_REGION_USER_HIST");

                entity.HasComment("History of association between USER and REGION defining which users can submit or access data.");

                entity.HasIndex(e => new { e.RegionUserHistId, e.EndDateHist }, "CRT_REGION_U_H_UK")
                    .IsUnique();

                entity.Property(e => e.RegionUserHistId)
                    .HasColumnName("REGION_USER_HIST_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_REGION_USER_H_ID_SEQ])")
                    .HasComment("Unique identifier for REGION History");

                entity.Property(e => e.AppCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_CREATE_TIMESTAMP")
                    .HasComment("Date and time of record creation");

                entity.Property(e => e.AppCreateUserGuid)
                    .HasColumnName("APP_CREATE_USER_GUID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_CREATE_USERID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time of last record update");

                entity.Property(e => e.AppLastUpdateUserGuid)
                    .HasColumnName("APP_LAST_UPDATE_USER_GUID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.AppLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_LAST_UPDATE_USERID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.EffectiveDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("EFFECTIVE_DATE_HIST")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.EndDate)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE")
                    .HasComment("Date reflecting when a user can no longer transmit submissions.");

                entity.Property(e => e.EndDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE_HIST");

                entity.Property(e => e.RegionId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("REGION_ID")
                    .HasComment("identifier for REGION");

                entity.Property(e => e.RegionUserId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("REGION_USER_ID")
                    .HasComment("Unique identifier for REGION");

                entity.Property(e => e.SystemUserId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("SYSTEM_USER_ID")
                    .HasComment("Unique identifier of related user");
            });

            modelBuilder.Entity<CrtRole>(entity =>
            {
                entity.HasKey(e => e.RoleId)
                    .HasName("CRT_ROLE_PK");

                entity.ToTable("CRT_ROLE");

                entity.HasComment("Role description table for groups of permissions.");

                entity.Property(e => e.RoleId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("ROLE_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_RL_ID_SEQ])")
                    .HasComment("Unique identifier for a record");

                entity.Property(e => e.AppCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_CREATE_TIMESTAMP")
                    .HasComment("Date and time of record creation");

                entity.Property(e => e.AppCreateUserGuid)
                    .HasColumnName("APP_CREATE_USER_GUID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_CREATE_USERID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time of last record update");

                entity.Property(e => e.AppLastUpdateUserGuid)
                    .HasColumnName("APP_LAST_UPDATE_USER_GUID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.AppLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_LAST_UPDATE_USERID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasDefaultValueSql("((1))")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.Description)
                    .HasMaxLength(150)
                    .IsUnicode(false)
                    .HasColumnName("DESCRIPTION")
                    .HasComment("Description of a permission.");

                entity.Property(e => e.EndDate)
                    .HasColumnType("date")
                    .HasColumnName("END_DATE")
                    .HasComment("Date permission was deactivated");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("NAME")
                    .HasComment("Business name for a permission");
            });

            modelBuilder.Entity<CrtRoleHist>(entity =>
            {
                entity.HasKey(e => e.RoleHistId)
                    .HasName("CRT_RL_H_PK");

                entity.ToTable("CRT_ROLE_HIST");

                entity.HasComment("Role History description table for groups of permissions.");

                entity.HasIndex(e => new { e.RoleHistId, e.EndDateHist }, "CRT_RL_H_UK")
                    .IsUnique();

                entity.Property(e => e.RoleHistId)
                    .HasColumnName("ROLE_HIST_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_ROLE_H_ID_SEQ])");

                entity.Property(e => e.AppCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_CREATE_TIMESTAMP")
                    .HasComment("Date and time of record creation");

                entity.Property(e => e.AppCreateUserGuid)
                    .HasColumnName("APP_CREATE_USER_GUID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_CREATE_USERID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time of last record update");

                entity.Property(e => e.AppLastUpdateUserGuid)
                    .HasColumnName("APP_LAST_UPDATE_USER_GUID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.AppLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_LAST_UPDATE_USERID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasDefaultValueSql("((1))")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.Description)
                    .HasMaxLength(150)
                    .IsUnicode(false)
                    .HasColumnName("DESCRIPTION")
                    .HasComment("Description of a permission.");

                entity.Property(e => e.EffectiveDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("EFFECTIVE_DATE_HIST")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.EndDate)
                    .HasColumnType("date")
                    .HasColumnName("END_DATE")
                    .HasComment("Date permission was deactivated");

                entity.Property(e => e.EndDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE_HIST");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("NAME")
                    .HasComment("Business name for a permission");

                entity.Property(e => e.RoleId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("ROLE_ID")
                    .HasComment("Unique identifier for a record");
            });

            modelBuilder.Entity<CrtRolePermission>(entity =>
            {
                entity.HasKey(e => e.RolePermissionId)
                    .HasName("CRT_RL_PERM_PK");

                entity.ToTable("CRT_ROLE_PERMISSION");

                entity.HasComment("Role to Permission associative table for assignment of permissions to parent roles.");

                entity.HasIndex(e => e.PermissionId, "CRT_RL_PERM_PERM_FK_I");

                entity.HasIndex(e => e.RoleId, "CRT_RL_PERM_RL_FK_I");

                entity.HasIndex(e => new { e.RoleId, e.PermissionId, e.EndDate }, "CRT_RL_PERM_UN_CH")
                    .IsUnique();

                entity.Property(e => e.RolePermissionId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("ROLE_PERMISSION_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_RL_PERM_ID_SEQ])")
                    .HasComment("Unique identifier for a record");

                entity.Property(e => e.AppCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_CREATE_TIMESTAMP")
                    .HasComment("Date and time of record creation");

                entity.Property(e => e.AppCreateUserGuid)
                    .HasColumnName("APP_CREATE_USER_GUID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_CREATE_USERID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time of last record update");

                entity.Property(e => e.AppLastUpdateUserGuid)
                    .HasColumnName("APP_LAST_UPDATE_USER_GUID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.AppLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_LAST_UPDATE_USERID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasDefaultValueSql("((1))")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.EndDate)
                    .HasColumnType("date")
                    .HasColumnName("END_DATE")
                    .HasComment("Date record was deactivated");

                entity.Property(e => e.PermissionId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("PERMISSION_ID")
                    .HasComment("Unique idenifier for related permission");

                entity.Property(e => e.RoleId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("ROLE_ID")
                    .HasComment("Unique idenifier for related role");

                entity.HasOne(d => d.Permission)
                    .WithMany(p => p.CrtRolePermissions)
                    .HasForeignKey(d => d.PermissionId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("CRT_PERMISSION_CRT_ROLE_PERMISSION");

                entity.HasOne(d => d.Role)
                    .WithMany(p => p.CrtRolePermissions)
                    .HasForeignKey(d => d.RoleId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("CRT_ROLE_CRT_ROLE_PERMISSION");
            });

            modelBuilder.Entity<CrtRolePermissionHist>(entity =>
            {
                entity.HasKey(e => e.RolePermissionHistId)
                    .HasName("CRT_RL_PE_H_PK");

                entity.ToTable("CRT_ROLE_PERMISSION_HIST");

                entity.HasComment("History of Role to Permission associative table for assignment of permissions to parent roles.");

                entity.HasIndex(e => new { e.EndDateHist, e.RolePermissionHistId }, "CRT_RL_PE_H_UK")
                    .IsUnique();

                entity.Property(e => e.RolePermissionHistId)
                    .HasColumnName("ROLE_PERMISSION_HIST_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_ROLE_PERMISSION_H_ID_SEQ])")
                    .HasComment("Unique identifier for a record");

                entity.Property(e => e.AppCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_CREATE_TIMESTAMP")
                    .HasComment("Date and time of record creation");

                entity.Property(e => e.AppCreateUserGuid)
                    .HasColumnName("APP_CREATE_USER_GUID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_CREATE_USERID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time of last record update");

                entity.Property(e => e.AppLastUpdateUserGuid)
                    .HasColumnName("APP_LAST_UPDATE_USER_GUID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.AppLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_LAST_UPDATE_USERID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.EffectiveDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("EFFECTIVE_DATE_HIST")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.EndDate)
                    .HasColumnType("date")
                    .HasColumnName("END_DATE")
                    .HasComment("Date record was deactivated");

                entity.Property(e => e.EndDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE_HIST")
                    .HasComment("Date record was deactivated");

                entity.Property(e => e.PermissionId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("PERMISSION_ID")
                    .HasComment("Unique idenifier for related permission");

                entity.Property(e => e.RoleId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("ROLE_ID")
                    .HasComment("Unique idenifier for related role");

                entity.Property(e => e.RolePermissionId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("ROLE_PERMISSION_ID")
                    .HasComment("Unique identifier for a record");
            });

            modelBuilder.Entity<CrtServiceArea>(entity =>
            {
                entity.HasKey(e => e.ServiceAreaId)
                    .HasName("CRT_SERVICE_AREA_PK");

                entity.ToTable("CRT_SERVICE_AREA");

                entity.HasComment("Service Area lookup values");

                entity.HasIndex(e => new { e.ServiceAreaNumber, e.ServiceAreaName, e.EndDate }, "CRT_SRV_ARA_UK")
                    .IsUnique();

                entity.Property(e => e.ServiceAreaId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("SERVICE_AREA_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_SRV_ARA_ID_SEQ])")
                    .HasComment("Unique idenifier for table records");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasDefaultValueSql("((1))")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.DistrictId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("DISTRICT_ID")
                    .HasComment("Unique identifier for DISTRICT.");

                entity.Property(e => e.EndDate)
                    .HasColumnType("date")
                    .HasColumnName("END_DATE")
                    .HasComment("Date the entity ends or changes");

                entity.Property(e => e.ServiceAreaName)
                    .IsRequired()
                    .HasMaxLength(60)
                    .IsUnicode(false)
                    .HasColumnName("SERVICE_AREA_NAME")
                    .HasComment("Name of the service area");

                entity.Property(e => e.ServiceAreaNumber)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("SERVICE_AREA_NUMBER")
                    .HasComment("Assigned number of the Service Area");

                entity.HasOne(d => d.District)
                    .WithMany(p => p.CrtServiceAreas)
                    .HasForeignKey(d => d.DistrictId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("CRT_DISTRICT_CRT_SERVICE_AREA");
            });

            modelBuilder.Entity<CrtServiceAreaHist>(entity =>
            {
                entity.HasKey(e => e.ServiceAreaHistId)
                    .HasName("CRT_SRV_A_H_PK");

                entity.ToTable("CRT_SERVICE_AREA_HIST");

                entity.HasComment("Service Area lookup values");

                entity.HasIndex(e => new { e.ServiceAreaHistId, e.EndDateHist }, "CRT_SRV_A_H_UK")
                    .IsUnique();

                entity.Property(e => e.ServiceAreaHistId)
                    .HasColumnName("SERVICE_AREA_HIST_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_SRV_ARA_ID_SEQ])")
                    .HasComment("Unique idenifier for history table records ");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasDefaultValueSql("((1))")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.DistrictId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("DISTRICT_ID")
                    .HasComment("Unique identifier for DISTRICT.");

                entity.Property(e => e.EffectiveDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("EFFECTIVE_DATE_HIST")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.EndDate)
                    .HasColumnType("date")
                    .HasColumnName("END_DATE")
                    .HasComment("Date the entity ends or changes");

                entity.Property(e => e.EndDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE_HIST");

                entity.Property(e => e.ServiceAreaId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("SERVICE_AREA_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_SRV_ARA_ID_SEQ])")
                    .HasComment("Unique idenifier for table records");

                entity.Property(e => e.ServiceAreaName)
                    .IsRequired()
                    .HasMaxLength(60)
                    .IsUnicode(false)
                    .HasColumnName("SERVICE_AREA_NAME")
                    .HasComment("Name of the service area");

                entity.Property(e => e.ServiceAreaNumber)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("SERVICE_AREA_NUMBER")
                    .HasComment("Assigned number of the Service Area");
            });

            modelBuilder.Entity<CrtSystemUser>(entity =>
            {
                entity.HasKey(e => e.SystemUserId)
                    .HasName("CRT_SYSTEM_USER_PK");

                entity.ToTable("CRT_SYSTEM_USER");

                entity.HasComment("Defines users and their attributes as found in IDIR");

                entity.Property(e => e.SystemUserId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("SYSTEM_USER_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [SYS_USR_ID_SEQ])")
                    .HasComment("A system generated unique identifier.");

                entity.Property(e => e.ApiClientId)
                    .HasMaxLength(40)
                    .IsUnicode(false)
                    .HasColumnName("API_CLIENT_ID")
                    .HasComment("This ID is used to track Keycloak client ID created for the users");

                entity.Property(e => e.AppCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_CREATE_TIMESTAMP")
                    .HasComment("Date and time of record creation");

                entity.Property(e => e.AppCreateUserGuid)
                    .HasColumnName("APP_CREATE_USER_GUID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_CREATE_USERID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time of last record update");

                entity.Property(e => e.AppLastUpdateUserGuid)
                    .HasColumnName("APP_LAST_UPDATE_USER_GUID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.AppLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_LAST_UPDATE_USERID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasDefaultValueSql("((1))")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.Email)
                    .HasMaxLength(100)
                    .IsUnicode(false)
                    .HasColumnName("EMAIL")
                    .HasComment("Contact email address within Active Directory (Email = SMGOV_EMAIL)");

                entity.Property(e => e.EndDate)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE")
                    .HasComment("Date a user can no longer access the system or invoke data submissions.");

                entity.Property(e => e.FirstName)
                    .HasMaxLength(150)
                    .IsUnicode(false)
                    .HasColumnName("FIRST_NAME")
                    .HasComment("First Name of the user");

                entity.Property(e => e.IsProjectMgr)
                    .HasColumnName("IS_PROJECT_MGR")
                    .HasComment("Identifies whether or not an individual is a project manager");

                entity.Property(e => e.LastName)
                    .HasMaxLength(150)
                    .IsUnicode(false)
                    .HasColumnName("LAST_NAME")
                    .HasComment("Last Name of the user");

                entity.Property(e => e.UserGuid)
                    .HasColumnName("USER_GUID")
                    .HasComment("A system generated unique identifier.  Reflects the active directory unique idenifier for the user.");

                entity.Property(e => e.Username)
                    .IsRequired()
                    .HasMaxLength(32)
                    .IsUnicode(false)
                    .HasColumnName("USERNAME")
                    .HasComment("IDIR or BCeID Active Directory defined universal identifier (SM_UNIVERSALID or userID) attributed to a user.  This value can change over time, while USER_GUID will remain consistant.");
            });

            modelBuilder.Entity<CrtSystemUserHist>(entity =>
            {
                entity.HasKey(e => e.SystemUserHistId)
                    .HasName("CRT_SYS_U_H_PK");

                entity.ToTable("CRT_SYSTEM_USER_HIST");

                entity.HasIndex(e => new { e.SystemUserHistId, e.EndDateHist }, "CRT_SYS_U_H_UK")
                    .IsUnique();

                entity.Property(e => e.SystemUserHistId)
                    .HasColumnName("SYSTEM_USER_HIST_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_SYSTEM_USER_H_ID_SEQ])");

                entity.Property(e => e.ApiClientId)
                    .HasMaxLength(40)
                    .IsUnicode(false)
                    .HasColumnName("API_CLIENT_ID")
                    .HasComment("This ID is used to track Keycloak client ID created for the users");

                entity.Property(e => e.AppCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_CREATE_TIMESTAMP")
                    .HasComment("Date and time of record creation");

                entity.Property(e => e.AppCreateUserGuid)
                    .HasColumnName("APP_CREATE_USER_GUID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_CREATE_USERID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time of last record update");

                entity.Property(e => e.AppLastUpdateUserGuid)
                    .HasColumnName("APP_LAST_UPDATE_USER_GUID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.AppLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_LAST_UPDATE_USERID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.EffectiveDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("EFFECTIVE_DATE_HIST")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.Email)
                    .HasMaxLength(100)
                    .IsUnicode(false)
                    .HasColumnName("EMAIL")
                    .HasComment("Contact email address within Active Directory (Email = SMGOV_EMAIL)");

                entity.Property(e => e.EndDate)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE")
                    .HasComment("Date a user can no longer access the system or invoke data submissions.");

                entity.Property(e => e.EndDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE_HIST");

                entity.Property(e => e.FirstName)
                    .HasMaxLength(150)
                    .IsUnicode(false)
                    .HasColumnName("FIRST_NAME")
                    .HasComment("First Name of the user");

                entity.Property(e => e.IsProjectMgr)
                    .HasColumnName("IS_PROJECT_MGR")
                    .HasComment("Identifies whether or not an individual is a project manager");

                entity.Property(e => e.LastName)
                    .HasMaxLength(150)
                    .IsUnicode(false)
                    .HasColumnName("LAST_NAME")
                    .HasComment("Last Name of the user");

                entity.Property(e => e.SystemUserId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("SYSTEM_USER_ID")
                    .HasComment("A system generated unique identifier.");

                entity.Property(e => e.UserGuid)
                    .HasColumnName("USER_GUID")
                    .HasComment("A system generated unique identifier.  Reflects the active directory unique idenifier for the user.");

                entity.Property(e => e.Username)
                    .IsRequired()
                    .HasMaxLength(32)
                    .IsUnicode(false)
                    .HasColumnName("USERNAME")
                    .HasComment("IDIR Active Directory defined universal identifier (SM_UNIVERSALID or userID) attributed to a user.  This value can change over time, while USER_GUID will remain consistant.");
            });

            modelBuilder.Entity<CrtUserRole>(entity =>
            {
                entity.HasKey(e => e.UserRoleId)
                    .HasName("CRT_USR_RL_PK");

                entity.ToTable("CRT_USER_ROLE");

                entity.HasComment("Associative table for assignment of roles to individual system users.");

                entity.HasIndex(e => e.RoleId, "CRT_USR_RL_RL_FK_I");

                entity.HasIndex(e => new { e.EndDate, e.SystemUserId, e.RoleId }, "CRT_USR_RL_UQ_CH")
                    .IsUnique();

                entity.HasIndex(e => e.SystemUserId, "CRT_USR_RL_USR_FK_I");

                entity.Property(e => e.UserRoleId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("USER_ROLE_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_USR_RL_ID_SEQ])")
                    .HasComment("Unique identifier for a record");

                entity.Property(e => e.AppCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_CREATE_TIMESTAMP")
                    .HasComment("Date and time of record creation");

                entity.Property(e => e.AppCreateUserGuid)
                    .HasColumnName("APP_CREATE_USER_GUID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_CREATE_USERID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time of last record update");

                entity.Property(e => e.AppLastUpdateUserGuid)
                    .HasColumnName("APP_LAST_UPDATE_USER_GUID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.AppLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_LAST_UPDATE_USERID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasDefaultValueSql("((1))")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasDefaultValueSql("(getutcdate())")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasDefaultValueSql("(user_name())")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.EndDate)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE")
                    .HasComment("Date a user is no longer assigned the role.  The APP_CREATED_TIMESTAMP and the END_DATE can be used to determine which roles were assigned to a user at a given point in time.");

                entity.Property(e => e.RoleId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("ROLE_ID")
                    .HasComment("Unique identifier for related ROLE");

                entity.Property(e => e.SystemUserId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("SYSTEM_USER_ID")
                    .HasComment("Unique identifier for related SYSTEM USER");

                entity.HasOne(d => d.Role)
                    .WithMany(p => p.CrtUserRoles)
                    .HasForeignKey(d => d.RoleId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("CRT_USR_RL_RL_FK");

                entity.HasOne(d => d.SystemUser)
                    .WithMany(p => p.CrtUserRoles)
                    .HasForeignKey(d => d.SystemUserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("CRT_USR_RL_SYS_USR_FK");
            });

            modelBuilder.Entity<CrtUserRoleHist>(entity =>
            {
                entity.HasKey(e => e.UserRoleHistId)
                    .HasName("CRT_USR_R_H_PK");

                entity.ToTable("CRT_USER_ROLE_HIST");

                entity.HasComment("Associative table for assignment of roles to individual system users.");

                entity.HasIndex(e => new { e.UserRoleHistId, e.EndDateHist }, "CRT_USR_R_H_UK")
                    .IsUnique();

                entity.Property(e => e.UserRoleHistId)
                    .HasColumnName("USER_ROLE_HIST_ID")
                    .HasDefaultValueSql("(NEXT VALUE FOR [CRT_USER_ROLE_H_ID_SEQ])")
                    .HasComment("Unique identifier for a record history");

                entity.Property(e => e.AppCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_CREATE_TIMESTAMP")
                    .HasComment("Date and time of record creation");

                entity.Property(e => e.AppCreateUserGuid)
                    .HasColumnName("APP_CREATE_USER_GUID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_CREATE_USERID")
                    .HasComment("Unique idenifier of user who created record");

                entity.Property(e => e.AppLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("APP_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time of last record update");

                entity.Property(e => e.AppLastUpdateUserGuid)
                    .HasColumnName("APP_LAST_UPDATE_USER_GUID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.AppLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("APP_LAST_UPDATE_USERID")
                    .HasComment("Unique idenifier of user who last updated record");

                entity.Property(e => e.ConcurrencyControlNumber)
                    .HasColumnName("CONCURRENCY_CONTROL_NUMBER")
                    .HasComment("Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.");

                entity.Property(e => e.DbAuditCreateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_CREATE_TIMESTAMP")
                    .HasComment("Date and time record created in the database");

                entity.Property(e => e.DbAuditCreateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_CREATE_USERID")
                    .HasComment("Named database user who created record");

                entity.Property(e => e.DbAuditLastUpdateTimestamp)
                    .HasColumnType("datetime")
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_TIMESTAMP")
                    .HasComment("Date and time record was last updated in the database.");

                entity.Property(e => e.DbAuditLastUpdateUserid)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false)
                    .HasColumnName("DB_AUDIT_LAST_UPDATE_USERID")
                    .HasComment("Named database user who last updated record");

                entity.Property(e => e.EffectiveDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("EFFECTIVE_DATE_HIST")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.EndDate)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE")
                    .HasComment("Date a user is no longer assigned the role.  The APP_CREATED_TIMESTAMP and the END_DATE can be used to determine which roles were assigned to a user at a given point in time.");

                entity.Property(e => e.EndDateHist)
                    .HasColumnType("datetime")
                    .HasColumnName("END_DATE_HIST");

                entity.Property(e => e.RoleId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("ROLE_ID")
                    .HasComment("Unique identifier for related ROLE");

                entity.Property(e => e.SystemUserId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("SYSTEM_USER_ID")
                    .HasComment("Unique identifier for related SYSTEM USER");

                entity.Property(e => e.UserRoleId)
                    .HasColumnType("numeric(9, 0)")
                    .HasColumnName("USER_ROLE_ID")
                    .HasComment("Unique identifier for a record");
            });

            modelBuilder.HasSequence("CRT_CODE_LKUP_ID_SEQ")
                .HasMin(1)
                .HasMax(999999999);

            modelBuilder.HasSequence("CRT_CODE_LOOKUP_H_ID_SEQ")
                .HasMin(1)
                .HasMax(9999999999);

            modelBuilder.HasSequence("CRT_DIST_ID_SEQ")
                .HasMin(1)
                .HasMax(999999999);

            modelBuilder.HasSequence("CRT_PERM_ID_SEQ")
                .HasMin(1)
                .HasMax(999999999);

            modelBuilder.HasSequence("CRT_PERMISSION_H_ID_SEQ")
                .HasMin(1)
                .HasMax(2147483647);

            modelBuilder.HasSequence("CRT_REG_DIST_H_ID_SEQ")
                .HasMin(1)
                .HasMax(9999999999);

            modelBuilder.HasSequence("CRT_REG_DIST_ID_SEQ")
                .HasMin(1)
                .HasMax(9999999999);

            modelBuilder.HasSequence("CRT_REG_ID_SEQ")
                .HasMin(1)
                .HasMax(999999999);

            modelBuilder.HasSequence("CRT_REGION_USER_H_ID_SEQ")
                .HasMin(1)
                .HasMax(999999999999);

            modelBuilder.HasSequence("CRT_REGION_USR_ID_SEQ")
                .HasMin(1)
                .HasMax(999999999);

            modelBuilder.HasSequence("CRT_RL_ID_SEQ")
                .HasMin(1)
                .HasMax(999999999);

            modelBuilder.HasSequence("CRT_RL_PERM_ID_SEQ")
                .HasMin(1)
                .HasMax(999999999);

            modelBuilder.HasSequence("CRT_ROLE_H_ID_SEQ")
                .HasMin(1)
                .HasMax(2147483647);

            modelBuilder.HasSequence("CRT_ROLE_PERMISSION_H_ID_SEQ")
                .HasMin(1)
                .HasMax(2147483647);

            modelBuilder.HasSequence("CRT_SRV_ARA_ID_SEQ")
                .HasMin(1)
                .HasMax(9999999999);

            modelBuilder.HasSequence("CRT_SYSTEM_USER_H_ID_SEQ")
                .HasMin(1)
                .HasMax(2147483647);

            modelBuilder.HasSequence("CRT_USER_ROLE_H_ID_SEQ")
                .HasMin(1)
                .HasMax(2147483647);

            modelBuilder.HasSequence("CRT_USR_RL_ID_SEQ")
                .HasMin(1)
                .HasMax(999999999);

            modelBuilder.HasSequence("SYS_USR_ID_SEQ")
                .HasMin(1)
                .HasMax(999999999);

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
