// Hello-world example with WT4

#include <Wt/WBreak.h>
#include <Wt/WContainerWidget.h>
#include <Wt/WLineEdit.h>
#include <Wt/WPushButton.h>
#include <Wt/WText.h>

class HelloApp : public Wt::WApplication {
  public:
    HelloApp(const Wt::WEnvironment& env);

  private:
    Wt::WLineEdit *nameEdit;
    Wt::WText *greeting;
};

HelloApp::HelloApp(const Wt::WEnvironment& env)
  : Wt::WEnvironment(env) {

  setTitle("Hello, World!");
}

int
main(int argc, char **argv) {
  return Wt::WRun(argc, argv, [](const Wt::WEnvironment& env) {
      return std::make_unique<Hello>(env);
    }
  );
}
