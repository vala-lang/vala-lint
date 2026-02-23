// vala-lint=skip-file

int main (string[] args) {
    string a = "lorem ipsum";
    string b = "lorem […] ipsum"; // vala-lint=ellipsis
    string c = "lorem […] ipsum…"; // vala-lint=ellipsis

    return 0;
}
