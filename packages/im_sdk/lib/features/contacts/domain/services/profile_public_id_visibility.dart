enum ProfileEntrySource { standard, group }

class ProfileAccessContext {
  final ProfileEntrySource source;
  final Object? role;

  const ProfileAccessContext.standard()
      : source = ProfileEntrySource.standard,
        role = null;

  const ProfileAccessContext.group({this.role})
      : source = ProfileEntrySource.group;
}

bool canViewProfilePublicId(ProfileAccessContext context) {
  if (context.source != ProfileEntrySource.group) return true;
  final source = context.role?.toString().trim().toLowerCase() ?? '';
  final role = source.contains('.') ? source.split('.').last : source;
  return role == 'owner' ||
      role == 'superadmin' ||
      role == 'super_admin' ||
      role == 'admin' ||
      role == 'administrator';
}
