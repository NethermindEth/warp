export function writeWithDocumentation(documentation: string, body: string) {
  return documentation === '' ? body : `${documentation}\n${body}`;
}
