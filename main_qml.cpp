#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "growthcalculator.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Create and register the calculator object
    GrowthCalculator calculator;
    engine.rootContext()->setContextProperty("calculator", &calculator);

    // Load the QML file
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    engine.load(url);

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
