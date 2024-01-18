export function emailValidator(email) {
  const re = /\S+@\S+\.\S+/;
  if (!email) return "Email address is required.";
  if (!re.test(email)) return "Please enter a valid email address.";
  return "";
}
