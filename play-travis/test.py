import unittest

class NumbersTest(unittest.TestCase):

    def test_equal(self):
        a = 1
        self.assertEqual(1, 1)

if __name__ == '__main__':
    unittest.main()
