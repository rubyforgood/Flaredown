export function passwordValidator(password) {
  if (!password) return "Password is required.";
  if (password.length < 8)
    return "Password should contain at least 8 characters.";
  return "";
}
