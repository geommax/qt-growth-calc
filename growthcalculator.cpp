#include "growthcalculator.h"
#include <QThread>
#include <QTimer>
#include <cmath>
#include <iomanip>
#include <sstream>

GrowthCalculator::GrowthCalculator(QObject *parent)
    : QObject(parent)
{
}

GrowthCalculator::~GrowthCalculator()
{
}

void GrowthCalculator::updateCurrentStep(const QString &step)
{
    if (m_currentStep != step) {
        m_currentStep = step;
        emit currentStepChanged();
    }
}

void GrowthCalculator::updateLinearResult(const QString &result)
{
    if (m_linearResult != result) {
        m_linearResult = result;
        emit linearResultChanged();
    }
}

void GrowthCalculator::updateExponentialResult(const QString &result)
{
    if (m_exponentialResult != result) {
        m_exponentialResult = result;
        emit exponentialResultChanged();
    }
}

void GrowthCalculator::startCalculation()
{
    if (m_isCalculating) return;

    m_linearData.clear();
    m_exponentialData.clear();

    m_isCalculating = true;
    emit isCalculatingChanged();
    emit linearDataChanged();
    emit exponentialDataChanged();

    QTimer::singleShot(0, this, &GrowthCalculator::performCalculation);
}

void GrowthCalculator::stopCalculation()
{
    m_isCalculating = false;
    emit isCalculatingChanged();
}

void GrowthCalculator::performCalculation()
{
    if (m_exponent < 1) {
        updateCurrentStep("Exponent must be at least 1");
        m_isCalculating = false;
        emit isCalculatingChanged();
        return;
    }

    // Linear Growth Calculation
    updateCurrentStep("Calculating Linear Growth...");
    double linearResult = m_base;
    m_linearData.append(QPointF(1, linearResult));

    for (int i = 2; i <= m_exponent && m_isCalculating; i++) {
        QThread::msleep(500);  // 500ms delay for smoother animation

        linearResult = m_base * i;
        m_linearData.append(QPointF(i, linearResult));

        QString step = QString("Linear Step %1: %2 × %3 = %4")
                           .arg(i)
                           .arg(m_base)
                           .arg(i)
                           .arg(linearResult, 0, 'f', 2);
        updateCurrentStep(step);
        emit linearDataChanged();
    }

    if (!m_isCalculating) return;

    std::ostringstream oss;
    oss << std::fixed << std::setprecision(2) << linearResult;
    updateLinearResult(QString("Final Result: %1").arg(QString::fromStdString(oss.str())));

    // Exponential Growth Calculation
    updateCurrentStep("Calculating Exponential Growth...");
    double exponentialResult = m_base;
    m_exponentialData.append(QPointF(1, exponentialResult));

    for (int i = 2; i <= m_exponent && m_isCalculating; i++) {
        QThread::msleep(500);  // 500ms delay

        exponentialResult = std::pow(m_base, i);
        m_exponentialData.append(QPointF(i, exponentialResult));

        QString step = QString("Exponential Step %1: %2^%3 = %4")
                           .arg(i)
                           .arg(m_base)
                           .arg(i)
                           .arg(exponentialResult, 0, 'g', 6);
        updateCurrentStep(step);
        emit exponentialDataChanged();
    }

    if (!m_isCalculating) return;

    std::ostringstream ossExp;
    if (exponentialResult > 1e6 || (exponentialResult < 0.000001 && exponentialResult != 0)) {
        ossExp << std::scientific << std::setprecision(6) << exponentialResult;
    } else {
        ossExp << std::fixed << std::setprecision(2) << exponentialResult;
    }
    updateExponentialResult(QString("Final Result: %1").arg(QString::fromStdString(ossExp.str())));

    updateCurrentStep("Calculation Complete!");
    m_isCalculating = false;
    emit isCalculatingChanged();
    emit calculationFinished();
}
