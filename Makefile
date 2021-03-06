
R = Rscript $^ $@

RESDIR := results
DATADIR := input
FIGDIR := figures

default: $(addprefix ${RESDIR}/,scenarios.ssv parameters.rda)

${RESDIR} ${DATADIR} ${FIGDIR}:
	mkdir -p $@

${RESDIR}/scenarios.ssv: scenarios.R ${DATADIR}/scenarios.json | ${RESDIR}
	${R}

${RESDIR}/parameters.rda: parameters.R ${DATADIR}/parameters.json | ${RESDIR}
	${R}

LEN := $(shell cat ${RESDIR}/scenarios.ssv | wc -l | xargs)
SEQ := $(shell seq 1 ${LEN})

CORES ?= 8
SAMPS ?= 1e3

ARRAYID ?= 1

simtar: ${RESDIR}/bp_${ARRAYID}.rds

${RESDIR}/bp_%.rds: run_sims.R simulator.R | ${RESDIR}
	Rscript $^ `sed -n '$*p' ${RESDIR}/scenarios.ssv` ${CORES} ${SAMPS} $@

FIGTAR ?= png

figures: $(subst rds,${FIGTAR},$(subst ${RESDIR},${FIGDIR},$(wildcard ${RESDIR}/bp_*.rds)))

${FIGDIR}/bp_%.${FIGTAR}: plot_sims.R ${RESDIR}/bp_%.rds | ${FIGDIR}
	${R}