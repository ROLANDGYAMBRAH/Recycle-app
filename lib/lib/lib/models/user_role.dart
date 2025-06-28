enum UserRole { recycler, compounder, industry }

String userRoleToString(UserRole role) {
  switch (role) {
    case UserRole.recycler:
      return 'recycler';
    case UserRole.compounder:
      return 'compounder';
    case UserRole.industry:
      return 'industry';
  }
}

UserRole stringToUserRole(String role) {
  switch (role) {
    case 'compounder':
      return UserRole.compounder;
    case 'industry':
      return UserRole.industry;
    default:
      return UserRole.recycler;
  }
}

