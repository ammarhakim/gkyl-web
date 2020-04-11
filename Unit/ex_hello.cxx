// Hello-world example with WT4
//
// ./ex_hello --docroot . --http-address 0.0.0.0 --http-port 9090

#include <Wt/WApplication.h>
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
  : Wt::WApplication(env) {
  
  setTitle("Hello, World!");
  
  root()->addWidget(std::make_unique<Wt::WText>("Name: "));
  nameEdit = root()->addWidget(std::make_unique<Wt::WLineEdit>());
  Wt::WPushButton *btn = root()->addWidget(std::make_unique<Wt::WPushButton>("Say Hello"));
  
  greeting = root()->addWidget(std::make_unique<Wt::WText>());
  
  auto greet = [this] {
    greeting->setText("Hello " + nameEdit->text());
  };
  
  btn->clicked().connect(greet);
}

int
main(int argc, char **argv) {
  return Wt::WRun(argc, argv, [](const Wt::WEnvironment& env) {
      return std::make_unique<HelloApp>(env);
    }
  );
}
