#!/usr/bin/env python
"""
@author: Rohini Joshi 
"""
import sys
import time
from DIRAC.Core.Base import Script
Script.parseCommandLine()

from DIRAC.Core.Security.ProxyInfo import getProxyInfo
from DIRAC.Interfaces.API.Dirac import Dirac

# TODO Use DIRAC python API to construct job
jdl = ''

jdl += 'JobName = "SKA SRC test payload";\n'

# TODO Use DIRAC API to get available sites instead of hard-coded list
jdl += """Parameters = {"LCG.UKI-NORTHGRID-MAN-HEP.uk", "LCG.UKI-LT2-IC-HEP.uk", "LCG.UKI-LT2-QMUL.uk", "LCG.UKI-NORTHGRID-LANCS-HEP.uk",
                        "CLOUD.CERN-PROD.ch", "CLOUD.RAL-LCG2.uk", "CLOUD.UK-CAM-CUMULUS.uk", "VAC.UKI-LT2-UCL-HEP.uk",
                        "VAC.UKI-NORTHGRID-MAN-HEP.uk", "VAC.UKI-NORTHGRID-LIV-HEP.uk", "VAC.UKI-SCOTGRID-GLASGOW.uk"};\n"""

jdl += 'Site = "%s";\n'

jdl += 'Platform = "EL7";\n'

jdl += 'Executable = "TestPayload.sh";\n'
jdl += 'InputSandbox = "TestPayload.sh";\n'

jdl += 'StdOutput = "StdOut";\n'
jdl += 'StdError = "StdErr";\n'
jdl += 'OutputSandbox = {"StdOut", "StdErr"};\n'

# Create a unique Job Group for this set of jobs
try:
  diracUsername = getProxyInfo()['Value']['username']
except:
  print 'Failed to get DIRAC username. No proxy set up?'
  sys.exit(1)

jobGroup = diracUsername + time.strftime('.%Y%m%d%H%M%S') 
jdl += 'JobGroup = "' + jobGroup + '";\n'

print 'Will submit this DIRAC JDL:'
print '====='
print jdl
print '====='
print
# Submit the job(s)
print 'Attempting to submit job(s) in JobGroup ' + jobGroup
print
dirac = Dirac()
result = dirac.submitJob(jdl)
print '====='
print 'Submission Result: ',result
print '====='

if result['OK']:
  print 'Retrieve output with  dirac-wms-job-get-output --JobGroup ' + jobGroup
else:
  print 'There was a problem submitting your job(s) - see above!!!'
print
