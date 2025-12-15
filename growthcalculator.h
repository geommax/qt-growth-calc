#ifndef GROWTHCALCULATOR_H
#define GROWTHCALCULATOR_H

#include <QObject>
#include <QVector>
#include <QPointF>

class GrowthCalculator : public QObject {
    Q_OBJECT
    Q_PROPERTY(double base READ getBase WRITE setBase NOTIFY baseChanged)
    Q_PROPERTY(int exponent READ getExponent WRITE setExponent NOTIFY exponentChanged)
    Q_PROPERTY(bool isCalculating READ getIsCalculating NOTIFY isCalculatingChanged)
    Q_PROPERTY(QVector<QPointF> linearData READ getLinearData NOTIFY linearDataChanged)
    Q_PROPERTY(QVector<QPointF> exponentialData READ getExponentialData NOTIFY exponentialDataChanged)
    Q_PROPERTY(QString currentStep READ getCurrentStep NOTIFY currentStepChanged)
    Q_PROPERTY(QString linearResult READ getLinearResult NOTIFY linearResultChanged)
    Q_PROPERTY(QString exponentialResult READ getExponentialResult NOTIFY exponentialResultChanged)

public:
    explicit GrowthCalculator(QObject *parent = nullptr);
    ~GrowthCalculator();

    double getBase() const { return m_base; }
    void setBase(double value) {
        if (m_base != value) {
            m_base = value;
            emit baseChanged();
        }
    }

    int getExponent() const { return m_exponent; }
    void setExponent(int value) {
        if (m_exponent != value) {
            m_exponent = value;
            emit exponentChanged();
        }
    }

    bool getIsCalculating() const { return m_isCalculating; }
    QVector<QPointF> getLinearData() const { return m_linearData; }
    QVector<QPointF> getExponentialData() const { return m_exponentialData; }
    QString getCurrentStep() const { return m_currentStep; }
    QString getLinearResult() const { return m_linearResult; }
    QString getExponentialResult() const { return m_exponentialResult; }

public slots:
    void startCalculation();
    void stopCalculation();

signals:
    void baseChanged();
    void exponentChanged();
    void isCalculatingChanged();
    void linearDataChanged();
    void exponentialDataChanged();
    void currentStepChanged();
    void linearResultChanged();
    void exponentialResultChanged();
    void calculationFinished();

private slots:
    void performCalculation();

private:
    double m_base = 2.0;
    int m_exponent = 5;
    bool m_isCalculating = false;
    QVector<QPointF> m_linearData;
    QVector<QPointF> m_exponentialData;
    QString m_currentStep;
    QString m_linearResult;
    QString m_exponentialResult;

    void updateCurrentStep(const QString &step);
    void updateLinearResult(const QString &result);
    void updateExponentialResult(const QString &result);
};

#endif // GROWTHCALCULATOR_H
