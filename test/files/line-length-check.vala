// vala-lint=skip-file

int main (string[] args) {
    string a = "Lorem ipsum dolor sit amet, sed do eiusmod tempor incididunt ut labore aliqua.";
    // This is 70 characters but 140 bytes, it should still pass.
    string b = "éééééééééééééééééééééééééééééééééééééééééééééééééééééééééééééééééééééé";
    string c = /* Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore aliqua consectetur */ "aliqua.";
    string d = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";

    return 0;
}
