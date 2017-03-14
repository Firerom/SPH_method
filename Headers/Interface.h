///**************************************************************************
/// HEADER: Function That Load/Read Input Files And Generate Output Files
///**************************************************************************

#ifndef INTERFACE_H
#define INTERFACE_H
#include "Structures.h"
#include <map>
#include <chrono>
#include <ctime>
#include <cstdlib>
#include <sstream>
#include <iomanip>

// inputReader.cpp
void readParameter(std::string filename, Parameter* parameter);
void readGeometry(std::string filename, Field* currentField);
void readBrick(int type, std::ifstream* inFile, Field* currentField);



// writeField.cpp
std::string creatDirectory(std::string dirname);

void writeField(Field* field, double t, Parameter* parameter,
                std::string const &parameterFilename="Undefined",
                std::string const &geometryFilename="Undefined",
                std::string const &filename="result");

void paraView(std::string const &filename,
              int step,
              std::vector<double> const &pos,
              std::map<std::string, std::vector<double> *> const &scalars,
              std::map<std::string, std::vector<double> *> const &vectors);

void matlab(std::string const &filename,
              std::string const &parameterFilename,
              std::string const &geometryFilename,
              int step, Parameter* parameter,
              std::vector<double> const &pos,
              std::vector<double> const &speed,
              std::vector<double> const &density,
              std::vector<double> const &pressure,
              std::vector<double> const &mass);


#endif
