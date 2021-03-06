#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QMessageBox>
#include <QGraphicsView>
#include <QThread>
#include <QProcess>
#include <QDebug>

void someOutput(QProcess *myProcess){
  qDebug() << "out: " << myProcess->readAllStandardOutput();
  qDebug() << "envo: " << myProcess->environment();
  qDebug() << "error: " << myProcess->error();
}

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    setValidators();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked()
{
    int inp[] = {1};
    char * out = (char*) "";
    callOctave(inp, out);

    ui->statusBar->showMessage("please wait ...");
    QThread::msleep(700);
    ui->statusBar->clearMessage();
    QString fileName = "C://img.png";
    QImage image(fileName);
    ui->imageLabel->setPixmap(QPixmap::fromImage(image));
}

void MainWindow::clickMenuButton()
{
    // do nothing (so far)
}

void MainWindow::setValidators()
{
    QRegExp r3("[0-9][0-9][0-9]");
    QRegExp r6("[0-9][0-9][0-9][0-9][0-9][0-9]");

    ui->le_ca1->setValidator(new QRegExpValidator(r3, this));
    ui->le_ca2->setValidator(new QRegExpValidator(r3, this));
    ui->le_ca3->setValidator(new QRegExpValidator(r3, this));
    ui->le_ca4->setValidator(new QRegExpValidator(r3, this));
    ui->le_ca5->setValidator(new QRegExpValidator(r3, this));
    ui->le_ca6->setValidator(new QRegExpValidator(r3, this));
    ui->le_va->setValidator(new QRegExpValidator(r3, this));

    ui->le_maxf->setValidator(new QRegExpValidator(r6, this));
    ui->le_minf->setValidator(new QRegExpValidator(r6, this));
}

bool MainWindow::callOctave(int input[], char* output)
{
    int waitTime = 6000;
    // QString program = "c:\\windows\\system32\\cmd.exe";
    QString program = "C:\\cygwin64\\bin\\bash.exe";
    QStringList arguments;
    arguments << " "; // "C:\\temp\\enginepolar.m";

    QProcess *myProcess = new QProcess();
    //myProcess->setWorkingDirectory("C:\\temp");
    myProcess->start(program, QIODevice::ReadWrite); // start(program, arguments);

    if (myProcess->waitForStarted() == false) {
        qDebug() << "Error starting cmd.exe process";
        qDebug() << myProcess->errorString();

        return false;
    }

    // Show process output
    myProcess->waitForReadyRead(waitTime);
    someOutput(myProcess);
    myProcess->waitForReadyRead(waitTime);
    someOutput(myProcess);

    myProcess->write("ls\n");
//    myProcess->write("C:\\cygwin64\\bin\\bash.exe\n");
    myProcess->waitForBytesWritten(waitTime);
    myProcess->waitForReadyRead(waitTime);
    someOutput(myProcess);

    myProcess->waitForReadyRead(waitTime);
    someOutput(myProcess);

    myProcess->write("8*5\n");
    myProcess->waitForBytesWritten(waitTime);

    myProcess->waitForReadyRead(waitTime);
    someOutput(myProcess);

    myProcess->waitForReadyRead(waitTime);
    someOutput(myProcess);

//    //myProcess->write("ls");

//    myProcess->waitForReadyRead();
//    myProcess->waitForBytesWritten();
//    myProcess->waitForReadyRead();
//    qDebug() << myProcess->readAllStandardOutput();

    myProcess->close();

    return true;
}


