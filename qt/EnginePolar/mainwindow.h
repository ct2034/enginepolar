#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private:
    Ui::MainWindow *ui;
    void setValidators();
    bool callOctave(int input[], char* output);

private slots:
    void clickMenuButton();
    void on_pushButton_clicked();
};

#endif // MAINWINDOW_H
