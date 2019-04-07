import pylab
import scipy
x = scipy.linspace(-2,2,1000)
y1 = scipy.sqrt(1-(abs(x)-1)**2)
y2 = -3*scipy.sqrt(1-(abs(x)/2)**0.5)
pylab.fill_between(x, y1, color='red')
pylab.fill_between(x, y2, color='red')
pylab.xlim([-2.5, 2.5])
pylab.text(0, -0.4, 'I love python', fontsize=24, fontweight='bold',
           color='white', horizontalalignment='center')
pylab.savefig('heart.png')


ax = pylab.gca()
ax.yaxis.set_visible(False)
ax.xaxis.set_visible(False)
ax.text(1.5, -2.5, 'By: Ami')
pylab.show()
