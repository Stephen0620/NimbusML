# --------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
# --------------------------------------------------------------------------------------------
# - Generated by tools/entrypoint_compiler.py: do not edit by hand
"""
IidChangePointDetector
"""

__all__ = ["IidChangePointDetector"]


from ...entrypoints.timeseriesprocessingentrypoints_iidchangepointdetector import \
    timeseriesprocessingentrypoints_iidchangepointdetector
from ...utils.utils import trace
from ..base_pipeline_item import BasePipelineItem, DefaultSignature


class IidChangePointDetector(BasePipelineItem, DefaultSignature):
    """

    This transform detects the change-points in an i.i.d. sequence using
    adaptive kernel density estimation and martingales.

    .. remarks::
        ``IIDChangePointDetector`` assumes a sequence of data points that are
        independently sampled from one
        stationary distribution. `Adaptive kernel density estimation
        <https://en.wikipedia.org/wiki/Variable_kernel_density_estimation>`_
        is used to model the distribution.

        This transform detects
        change points by calculating the martingale score for the sliding
        window based on the estimated distribution.
        The idea is based on the `Exchangeability
        Martingales <https://icml.cc/Conferences/2012/papers/808.pdf>`_ that
        detects a change of distribution over a stream of i.i.d. values. In
        short, the value of the
        martingale score starts increasing significantly when a sequence of
        small p-values are detected in a row; this
        indicates the change of the distribution of the underlying data
        generation process.

    :param confidence: The confidence for change point detection in the range
        [0, 100]. Used to set the threshold of the martingale score for
        triggering alert.

    :param change_history_length: The length of the sliding window on p-value
        for computing the martingale score.

    :param martingale: The type of martingale betting function used for
        computing the martingale score. Available options are {``Power``,
        ``Mixture``}.

    :param power_martingale_epsilon: The epsilon parameter for the Power
        martingale if martingale is set to ``Power``.

    :param params: Additional arguments sent to compute engine.

    .. seealso::
        :py:func:`IIDSpikeDetector
        <nimbusml.preprocessing.timeseries.IIDSpikeDetector>`,
        :py:func:`SsaSpikeDetector
        <nimbusml.preprocessing.timeseries.SsaSpikeDetector>`,
        :py:func:`SsaChangePointDetector
        <nimbusml.preprocessing.timeseries.SsaChangePointDetector>`.

    .. index:: models, timeseries, transform

    Example:
       .. literalinclude::
        /../nimbusml/examples/IidSpikeChangePointDetector.py
              :language: python
    """

    @trace
    def __init__(
            self,
            confidence=95.0,
            change_history_length=20,
            martingale='Power',
            power_martingale_epsilon=0.1,
            **params):
        BasePipelineItem.__init__(
            self, type='transform', **params)

        self.confidence = confidence
        self.change_history_length = change_history_length
        self.martingale = martingale
        self.power_martingale_epsilon = power_martingale_epsilon

    @property
    def _entrypoint(self):
        return timeseriesprocessingentrypoints_iidchangepointdetector

    @trace
    def _get_node(self, **all_args):
        algo_args = dict(
            source=self.source,
            name=self._name_or_source,
            confidence=self.confidence,
            change_history_length=self.change_history_length,
            martingale=self.martingale,
            power_martingale_epsilon=self.power_martingale_epsilon)

        all_args.update(algo_args)
        return self._entrypoint(**all_args)
