FROM emptystackexn/multimlton
WORKDIR /heron
RUN git clone https://github.com/heron-solver/heron.git .
RUN make CC=multimlton
ENV PATH="/heron:${PATH}"



